# A stylesheet for DOAP files in XMPP software

**DOAP** ('Description Of A Project') is a [specification for describing software projects](https://github.com/ewilderj/doap/wiki).
It was extended to include implementation status of XEPs in XMPP software, see [XEP-0453](https://xmpp.org/extensions/xep-0453.html).

This XSL stylesheet makes DOAP files render nicely in web browsers with XSLT support.

## How to use

Reference the stylesheet in your DOAP xml file:

```xml
<?xml-stylesheet href="style.xsl" type="text/xsl"?>
```

That's it!

If you want to adapt the primary color of the rendering to _your_ client, just change the HSL color variables in `style.css` to your needs:

```css
:root {
    /* Primary color in HSL: Change this to customize all colored elements */
    --color-h: 210;
    --color-s: 13%;
    --color-l: 50%;
}
```

## Website integration

How does rendering a DOAP file on my website work? DOAP files can be rendered in an existing website (e.g. built using Hugo, Doxygen or other systems) by using an `<iframe>` element:

```html
<iframe src="doap.xml" width="100%" frameborder="0">
```

Since an `<iframe>`'s height cannot be determined before it is rendered, you can apply this javascript snippet to adjust the frame's height:

```js
function resizeIframe(iframe) {
    iframe.style.height = iframe.contentWindow.document.documentElement.scrollHeight + 20 + 'px';
}
```

You can either integrate this with your existing javascript, or add it to the frame's `onload` event:

```html
<iframe src="doap.xml" width="100%" frameborder="0" onload="resizeIframe(this)">
```

## Sample rendering

How does it look in the end? Have a look at [this sample rendering]( https://pulkomandy.github.io/xmpp-doap/samples/movim.xml).
