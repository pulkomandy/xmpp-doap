const rdf_ns = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
const doap_ns = 'http://usefulinc.com/ns/doap#';
const foaf_ns = 'http://xmlns.com/foaf/0.1/';
const xmpp_ns = 'https://linkmauve.fr/ns/xmpp-doap#';
const xhtml_ns = 'http://www.w3.org/1999/xhtml';

function get_element(elem, ns, name) {
	const list = elem.getElementsByTagNameNS(ns, name)
	if (list.length < 1)
		return null;
	return list[0];
}

function get_element_resource(elem, ns, name) {
	const list = elem.getElementsByTagNameNS(ns, name)
	if (list.length < 1)
		return null;
	const elem2 = list[0];
	if (elem2 === undefined)
		return null;
	return elem2.getAttributeNS(rdf_ns, 'resource');
}

function get_element_text(elem, ns, name) {
	const list = elem.getElementsByTagNameNS(ns, name)
	if (list.length < 1)
		return null;
	const elem2 = list[0];
	if (elem2 === undefined)
		return null;
	return elem2.textContent;
}

function parse_doap() {
	const xml = this.responseXML;
	const elem = xml.documentElement;
	const project = get_element(elem, doap_ns, 'Project');
	const name = get_element_text(elem, doap_ns, 'name');
	const homepage = get_element_resource(elem, doap_ns, 'homepage');
	const xmpp = get_element(elem, xmpp_ns, 'software');
	let type_elem = get_element(xmpp, xmpp_ns, 'Client');
	if (type_elem === undefined)
		type_elem = get_element(elem, xmpp_ns, 'Server');
	if (type_elem === undefined)
		type_elem = get_element(elem, xmpp_ns, 'Library');
	if (type_elem === undefined)
		type_elem = get_element(elem, xmpp_ns, 'Component');
	const type = type_elem.localName;
	const supports = type_elem.getElementsByTagNameNS(xmpp_ns, 'supports');
	const software = {
		name: name,
		homepage: homepage,
		type: type,
		xeps: {},
	};
	for (let support of supports) {
		const xep = get_element(support, xmpp_ns, 'SupportedXep');
		const xep_url = get_element_resource(xep, xmpp_ns, 'xep');
		const [_, number] = /https:\/\/xmpp\.org\/extensions\/xep-(\d\d\d\d)\.html/.exec(xep_url);
		const status = get_element_text(xep, xmpp_ns, 'status');
		const version = get_element_text(xep, xmpp_ns, 'version');
		const since = get_element_text(xep, xmpp_ns, 'since');
		const note = get_element_text(xep, xmpp_ns, 'note');
		software.xeps[number] = {
			number: number,
			status: status,
			version: version,
			since: since,
			note: note,
		};
	}

	update_display(software);
}

function send_request(filename) {
	const xhr = new window.XMLHttpRequest();
	xhr.addEventListener('load', parse_doap);
	xhr.open('GET', filename);
	xhr.send();
}

function update_display(software) {
	const {name, homepage} = software;
	const [_, number] = /xep-(\d\d\d\d)\.(?:x|ht)ml/.exec(document.location);
	const xep = software.xeps[number];
	const {status, version, since, note} = xep;
	console.log(name, homepage, status, version, since, note);
	const revision = document.getElementById('revision-history-v' + version);
	let support = document.getElementById('revision-history-v' + version + '-support');
	if (support === null) {
		const aside = document.createElementNS(xhtml_ns, 'aside');
		aside.style.border = '1px solid black';
		aside.style.float = 'right';
		const p = document.createElementNS(xhtml_ns, 'p');
		p.textContent = 'Support';
		aside.append(p);
		support = document.createElementNS(xhtml_ns, 'ul');
		support.setAttributeNS(null, 'id', 'revision-history-v' + version + '-support');
		aside.appendChild(support);
		revision.prepend(aside);
	}
	const li = document.createElementNS(xhtml_ns, 'li');
	const software_elem = document.createElementNS(xhtml_ns, 'a');
	software_elem.setAttributeNS(null, 'href', homepage);
	software_elem.textContent = name;
	li.appendChild(software_elem);
	support.appendChild(li);
}

(function(){
	send_request('../poezio.xml');
	send_request('../movim.xml');
})();
