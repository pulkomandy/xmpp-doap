const rdfNS = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
const doapNS = 'http://usefulinc.com/ns/doap#';
const foafNS = 'http://xmlns.com/foaf/0.1/';
const xmppNS = 'https://linkmauve.fr/ns/xmpp-doap#';
const xhtmlNS = 'http://www.w3.org/1999/xhtml';

function getElement(elem, ns, name) {
    const list = elem.getElementsByTagNameNS(ns, name)
    if (list.length < 1) return null;

    return list[0];
}

function getElementResource(elem, ns, name) {
    const list = elem.getElementsByTagNameNS(ns, name)
    if (list.length < 1) return null;

    const elem2 = list[0];
    if (elem2 === undefined) return null;

    return elem2.getAttributeNS(rdfNS, 'resource');
}

function getElementText(elem, ns, name) {
    const list = elem.getElementsByTagNameNS(ns, name)
    if (list.length < 1) return null;

    const elem2 = list[0];
    if (elem2 === undefined) return null;

    return elem2.textContent;
}

function parseDoap() {
    const xml = this.responseXML;
    const elem = xml.documentElement;
    const project = getElement(elem, doapNS, 'Project');
    const name = getElementText(elem, doapNS, 'name');
    const homepage = getElementResource(elem, doapNS, 'homepage');
    const xmpp = getElement(elem, xmppNS, 'software');
    let typeElem = getElement(xmpp, xmppNS, 'Client');
    if (typeElem === undefined)
        typeElem = getElement(elem, xmppNS, 'Server');
    if (typeElem === undefined)
        typeElem = getElement(elem, xmppNS, 'Library');
    if (typeElem === undefined)
        typeElem = getElement(elem, xmppNS, 'Component');
    const type = typeElem.localName;
    const supports = typeElem.getElementsByTagNameNS(xmppNS, 'supports');
    const software = {
        name: name,
        homepage: homepage,
        type: type,
        xeps: {},
    };

    for (let support of supports) {
        const xep = getElement(support, xmppNS, 'SupportedXep');
        const xep_url = getElementResource(xep, xmppNS, 'xep');
        const [_, number] = /https:\/\/xmpp\.org\/extensions\/xep-(\d\d\d\d)\.html/.exec(xep_url);
        const status = getElementText(xep, xmppNS, 'status');
        const version = getElementText(xep, xmppNS, 'version');
        const since = getElementText(xep, xmppNS, 'since');
        const note = getElementText(xep, xmppNS, 'note');
        software.xeps[number] = {
            number: number,
            status: status,
            version: version,
            since: since,
            note: note,
        };
    }

    updateDisplay(software);
}

function sendRequest(filename) {
    const xhr = new window.XMLHttpRequest();
    xhr.addEventListener('load', parseDoap);
    xhr.open('GET', filename);
    xhr.send();
}

function updateDisplay(software) {
    const {name, homepage, type} = software;
    const [_, number] = /xep-(\d\d\d\d)\.(?:x|ht)ml/.exec(document.location);
    const xep = software.xeps[number];
    const {status, version, since, note} = xep;

    const docmeta = document.querySelector('.docmeta-wrap');
    let support = document.querySelector('figure#support');

    if (support === null) {
        const figure = document.createElementNS(xhtmlNS, 'figure');
        figure.id = 'support';
        figure.classList.add('table');

        const figureCaption = document.createElementNS(xhtmlNS, 'figcaption');
        figureCaption.id = 'support';
        figureCaption.textContent = 'Software support'
        figure.appendChild(figureCaption);

        const table = document.createElementNS(xhtmlNS, 'table');
        figure.appendChild(table);

        const tbody = document.createElementNS(xhtmlNS, 'tbody');
        table.appendChild(tbody);

        const tr = document.createElementNS(xhtmlNS, 'tr');
        tr.classList.add('body');
        tbody.appendChild(tr);

        const thSoftware = document.createElementNS(xhtmlNS, 'th');
        thSoftware.textContent = 'Software';
        tr.appendChild(thSoftware);

        const thType = document.createElementNS(xhtmlNS, 'th');
        thType.textContent = 'Type';
        tr.appendChild(thType);

        const thVersion = document.createElementNS(xhtmlNS, 'th');
        thVersion.textContent = 'Version';
        tr.appendChild(thVersion);

        const thSupport = document.createElementNS(xhtmlNS, 'th');
        thSupport.textContent = 'Support';
        tr.appendChild(thSupport);

        docmeta.after(figure);

        support = figure;
    }

    const tbody = support.querySelector('tbody');

    const tr = document.createElementNS(xhtmlNS, 'tr');
    tr.classList.add('body');
    tbody.appendChild(tr);

    const tdClient = document.createElementNS(xhtmlNS, 'td');
    const aClient = document.createElementNS(xhtmlNS, 'a');
    aClient.href = homepage;
    aClient.textContent = name;
    tdClient.appendChild(aClient);
    tr.appendChild(tdClient);

    const tdType = document.createElementNS(xhtmlNS, 'td');
    tdType.textContent = type;
    tr.appendChild(tdType);

    const tdVersion = document.createElementNS(xhtmlNS, 'td');
    const aVersion = document.createElementNS(xhtmlNS, 'a');
    aVersion.href = '#revision-history-v' + version;
    aVersion.textContent = version;
    tdVersion.appendChild(aVersion);
    tr.appendChild(tdVersion);

    const tdSupport = document.createElementNS(xhtmlNS, 'td');
    tdSupport.textContent = status;

    if (note !== null) {
        const abbr = document.createElementNS(xhtmlNS, 'abbr');
        abbr.textContent = '*';
        abbr.title = note;
        tdSupport.appendChild(abbr);
    }

    tr.appendChild(tdSupport);
}

(function(){
    sendRequest('../poezio.xml');
    sendRequest('../movim.xml');
})();
