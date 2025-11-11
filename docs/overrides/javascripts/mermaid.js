document$.subscribe(() => {
	if (typeof mermaid !== "undefined") {
		mermaid.initialize({
			startOnLoad: false,
			theme:
				document
					.querySelector("[data-md-color-scheme]")
					.getAttribute("data-md-color-scheme") === "slate"
					? "dark"
					: "default",
			themeVariables: {
				primaryColor: "#0f4c75",
				primaryTextColor: "#fff",
				primaryBorderColor: "#3282b8",
				lineColor: "#757575",
				secondaryColor: "#006100",
				tertiaryColor: "#fff",
			},
			flowchart: {
				htmlLabels: false,
			},
			sequence: {
				diagramMarginX: 50,
				diagramMarginY: 10,
				actorMargin: 50,
				width: 150,
				height: 65,
				boxMargin: 10,
				boxTextMargin: 5,
				noteMargin: 10,
				messageMargin: 35,
				mirrorActors: true,
				bottomMarginAdj: 1,
				useMaxWidth: true,
				rightAngles: false,
				showSequenceNumbers: false,
			},
			gantt: {
				leftPadding: 75,
				gridLineStartPadding: 35,
				fontSize: 11,
				sectionFontSize: 11,
				numberSectionStyles: 4,
			},
		});

		const observer = new MutationObserver(() => {
			document.querySelectorAll("pre code.mermaid").forEach((block) => {
				if (!block.hasAttribute("data-processed")) {
					block.setAttribute("data-processed", "true");

					const container = document.createElement("div");
					container.className = "mermaid-container";
					container.style.textAlign = "center";
					container.style.margin = "2rem 0";

					const pre = block.parentNode;
					pre.parentNode.insertBefore(container, pre);

					try {
						mermaid.render(
							"mermaid-" + Math.random().toString(36).substr(2, 9),
							block.textContent,
							(svgCode) => {
								container.innerHTML = svgCode;
								pre.style.display = "none";
							},
						);
					} catch (error) {
						console.error("Mermaid rendering error:", error);
						container.innerHTML = `<div class="mermaid-error">Error rendering diagram: ${error.message}</div>`;
					}
				}
			});
		});

		observer.observe(document.body, {
			childList: true,
			subtree: true,
		});

		// Initial scan for existing diagrams
		document.querySelectorAll("pre code.mermaid").forEach((block) => {
			if (!block.hasAttribute("data-processed")) {
				const event = new MutationRecord();
				event.type = "childList";
				observer.callback([event]);
			}
		});
	}
});

// Handle theme changes
document.addEventListener("DOMContentLoaded", () => {
	const schemeToggle = document.querySelector("[data-md-color-scheme]");
	if (schemeToggle) {
		const observer = new MutationObserver(() => {
			if (typeof mermaid !== "undefined") {
				const isDark =
					document
						.querySelector("[data-md-color-scheme]")
						.getAttribute("data-md-color-scheme") === "slate";
				mermaid.initialize({
					theme: isDark ? "dark" : "default",
				});

				// Re-render existing diagrams
				document.querySelectorAll(".mermaid-container").forEach((container) => {
					const pre = container.nextElementSibling;
					if (pre && pre.tagName === "PRE") {
						const code = pre.querySelector("code.mermaid");
						if (code) {
							try {
								mermaid.render(
									"mermaid-" + Math.random().toString(36).substr(2, 9),
									code.textContent,
									(svgCode) => {
										container.innerHTML = svgCode;
									},
								);
							} catch (error) {
								console.error("Mermaid re-rendering error:", error);
							}
						}
					}
				});
			}
		});

		observer.observe(document.documentElement, {
			attributes: true,
			attributeFilter: ["data-md-color-scheme"],
		});
	}
});
