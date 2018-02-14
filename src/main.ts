import './main.scss';
import './index.html';

import 'reveal.js/lib/js/classList.js';
import 'reveal.js/lib/js/html5shiv.js';

import * as Reveal from 'reveal.js';

function init(event: Event) {
	Reveal.initialize({
		autoSlide: 0,
		backgroundTransition: 'slide',
		controls: false
	});

	event.target.removeEventListener(event.type, init);
}

document.addEventListener('DOMContentLoaded', init);
