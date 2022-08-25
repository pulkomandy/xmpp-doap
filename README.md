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

Sample rendering: https://pulkomandy.github.io/xmpp-doap/samples/movim.xml
