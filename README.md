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

Most web browsers natively support XSLT, so, people opening your file in a web browser will now see a nice webpage. And computers can easily make sense of the raw XML data which is presented to them in a standardized way.

If you want to adapt the primary color of the rendering to _your_ client, just change the HSL color variables in `style.css` to your needs:

```css
:root {
    /* Primary color in HSL: Change this to customize all colored elements */
    --color-h: 210;
    --color-s: 13%;
    --color-l: 50%;
}
```

## Sample rendering

How does it look in the end? Have a look at [this sample rendering]( https://pulkomandy.github.io/xmpp-doap/samples/movim.xml).

## Website integration

DOAP files can be rendered in an existing website (e.g. built using Hugo, Doxygen or other systems) by using an `<iframe>` element.

### Prerequisites

How does rendering a DOAP file on my website work? You need:

* a [DOAP](https://xmpp.org/extensions/xep-0453.html) file (here: `doap.xml`) for your project
* [style.xsl](/style.xsl) from this repository
* [style.css](/style.css) from this repository
* optional: [xeplist.xml](https://xmpp.org/extensions/xeplist.xml) from xmpp.org

### Adapt files to your needs

A few URLs need to be adapted to your website's structure.

1. Add the stylesheet to your `doap.xml`:

    ```xml
    <?xml-stylesheet href="style.xsl" type="text/xsl"?>
    ```

1. Make sure that `style.xsl` points to where you store `style.css` on your website:

    ```xml
    <link href="style.css" type="text/css" rel="stylesheet"/>
    ```
1. Optional: Download [xeplist.xml](https://xmpp.org/extensions/xeplist.xml) from xmpp.org, and reference it in `style.xsl`:

    ```xml
    <xsl:variable
         name="xeplist"
         select="document('https://your-website.tld/xeplist.xml')/xep-infos"
    />
    ```
    
    Please note: This step is a workaround! Due to a [bug in Chromium](https://bugs.chromium.org/p/chromium/issues/detail?id=1035198), XSL files cannot request external resources, even if CORS headers are set correctly. Make sure to update `xeplist.xml` periodically, until this bug is fixed.

### Integrate it with your website

To integrate your DOAP file with your website, you need to add an `<iframe>` element:

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
