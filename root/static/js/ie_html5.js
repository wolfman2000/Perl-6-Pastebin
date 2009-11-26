/* Apply to IE to force recognition of tags. */

var elem = "abbr, article, aside, audio, bb, canvas";
    elem += ", datagrid, datalist, details, dialog";
    elem += ", eventsource, figure, footer, header";
    elem += ", mark, menu, meter, nav, output";
    elem += ", progress, section, time, video";

var list = elem.split(", ");

for (i = 0; i < list.length; i += 1)
{
    document.createElement(list[i]);
}
