// Mermaid zoom and pan enhancement
// Source: GZANSP Protocol - Method-First Architecture
// This script adds interactive zoom/pan controls to Mermaid diagrams
// Note: Mermaid is initialized by mermaid2 plugin

// Wait for mermaid2 plugin to finish rendering
document.addEventListener('DOMContentLoaded', function() {
    // Add zoom and pan functionality to all Mermaid diagrams
    function addZoomPan() {
        const mermaidDivs = document.querySelectorAll('.mermaid');

        mermaidDivs.forEach((div) => {
            // Skip if already processed
            if (div.classList.contains('zoom-enabled')) return;

            const svg = div.querySelector('svg');
            if (!svg) return;

            // Mark as processed
            div.classList.add('zoom-enabled');

            // Wrap SVG in a container for zoom/pan
            const wrapper = document.createElement('div');
            wrapper.className = 'mermaid-zoom-wrapper';
            wrapper.style.position = 'relative';
            wrapper.style.overflow = 'hidden';
            wrapper.style.border = '1px solid #e0e0e0';
            wrapper.style.borderRadius = '4px';
            wrapper.style.backgroundColor = '#fafafa';

            // Add control buttons
            const controls = document.createElement('div');
            controls.className = 'mermaid-controls';
            controls.style.position = 'absolute';
            controls.style.top = '10px';
            controls.style.right = '10px';
            controls.style.zIndex = '1000';
            controls.style.display = 'flex';
            controls.style.gap = '5px';

            const buttonStyle = `
                padding: 5px 10px;
                background: rgba(255,255,255,0.9);
                border: 1px solid #ccc;
                border-radius: 3px;
                cursor: pointer;
                font-size: 14px;
                transition: background 0.2s;
            `;

            // Zoom In button
            const zoomInBtn = document.createElement('button');
            zoomInBtn.innerHTML = '<span class="material-icons">zoom_in</span>';
            zoomInBtn.title = 'Zoom In';
            zoomInBtn.style.cssText = buttonStyle;
            zoomInBtn.onclick = () => zoom(svg, 1.2);

            // Zoom Out button
            const zoomOutBtn = document.createElement('button');
            zoomOutBtn.innerHTML = '<span class="material-icons">zoom_out</span>';
            zoomOutBtn.title = 'Zoom Out';
            zoomOutBtn.style.cssText = buttonStyle;
            zoomOutBtn.onclick = () => zoom(svg, 0.8);

            // Reset button
            const resetBtn = document.createElement('button');
            resetBtn.innerHTML = '<span class="material-icons">restart_alt</span>';
            resetBtn.title = 'Reset View';
            resetBtn.style.cssText = buttonStyle;
            resetBtn.onclick = () => resetView(svg);

            // Fit to screen button
            const fitBtn = document.createElement('button');
            fitBtn.innerHTML = '<span class="material-icons">fit_screen</span>';
            fitBtn.title = 'Fit to Screen';
            fitBtn.style.cssText = buttonStyle;
            fitBtn.onclick = () => fitToScreen(svg, wrapper);

            controls.appendChild(zoomInBtn);
            controls.appendChild(zoomOutBtn);
            controls.appendChild(resetBtn);
            controls.appendChild(fitBtn);

            // Replace div content with wrapped version
            div.parentNode.insertBefore(wrapper, div);
            wrapper.appendChild(div);
            wrapper.appendChild(controls);

            // Store original viewBox
            if (!svg.dataset.originalViewBox) {
                svg.dataset.originalViewBox = svg.getAttribute('viewBox') ||
                    `0 0 ${svg.clientWidth} ${svg.clientHeight}`;
            }

            // Enable pan on drag
            enablePan(svg, wrapper);
        });
    }

    // Zoom function
    function zoom(svg, factor) {
        const viewBox = svg.getAttribute('viewBox').split(' ').map(Number);
        const [x, y, width, height] = viewBox;

        const newWidth = width / factor;
        const newHeight = height / factor;
        const dx = (width - newWidth) / 2;
        const dy = (height - newHeight) / 2;

        svg.setAttribute('viewBox', `${x + dx} ${y + dy} ${newWidth} ${newHeight}`);
    }

    // Reset view function
    function resetView(svg) {
        const originalViewBox = svg.dataset.originalViewBox;
        if (originalViewBox) {
            svg.setAttribute('viewBox', originalViewBox);
        }
    }

    // Fit to screen function
    function fitToScreen(svg, wrapper) {
        const bbox = svg.getBBox();
        const padding = 20;
        svg.setAttribute('viewBox',
            `${bbox.x - padding} ${bbox.y - padding} ${bbox.width + padding * 2} ${bbox.height + padding * 2}`);
    }

    // Enable pan on drag
    function enablePan(svg, wrapper) {
        let isPanning = false;
        let startPoint = { x: 0, y: 0 };
        let viewBox = { x: 0, y: 0, width: 0, height: 0 };

        svg.style.cursor = 'grab';

        wrapper.addEventListener('mousedown', (e) => {
            isPanning = true;
            svg.style.cursor = 'grabbing';
            startPoint = { x: e.clientX, y: e.clientY };

            const vb = svg.getAttribute('viewBox').split(' ').map(Number);
            viewBox = { x: vb[0], y: vb[1], width: vb[2], height: vb[3] };
        });

        wrapper.addEventListener('mousemove', (e) => {
            if (!isPanning) return;

            const dx = (startPoint.x - e.clientX) * (viewBox.width / svg.clientWidth);
            const dy = (startPoint.y - e.clientY) * (viewBox.height / svg.clientHeight);

            svg.setAttribute('viewBox',
                `${viewBox.x + dx} ${viewBox.y + dy} ${viewBox.width} ${viewBox.height}`);
        });

        wrapper.addEventListener('mouseup', () => {
            isPanning = false;
            svg.style.cursor = 'grab';
        });

        wrapper.addEventListener('mouseleave', () => {
            if (isPanning) {
                isPanning = false;
                svg.style.cursor = 'grab';
            }
        });

        // Zoom on wheel
        wrapper.addEventListener('wheel', (e) => {
            e.preventDefault();
            const factor = e.deltaY < 0 ? 1.1 : 0.9;
            zoom(svg, factor);
        });
    }

    // Run after Mermaid renders
    const observer = new MutationObserver(() => {
        addZoomPan();
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });

    // Initial run
    setTimeout(addZoomPan, 500);
});
