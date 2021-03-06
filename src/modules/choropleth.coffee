###
    kartograph - a svg mapping library
    Copyright (C) 2011  Gregor Aisch

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

root = (exports ? this)
kartograph = root.$K = root.kartograph ?= {}

kartograph.Kartograph::choropleth = (opts) ->
    me = @
    layer_id = opts.layer ? me.layerIds[me.layerIds.length-1]

    if not me.layers.hasOwnProperty layer_id
        warn 'choropleth error: layer "'+layer_ihad+'" not found'
        return

    data = opts.data
    data_col = opts.value
    data_key = opts.key
    colors = opts.colors

    pathData = {}

    if data_key? and __type(data) == "array"
        for row in data
            id = row[data_key]
            pathData[String(id)] = row
    else
        for id, row of data
            pathData[String(id)] = row

    for id, paths of me.layers[layer_id].pathsById
        for path in paths
            pd = pathData[id] ? null
            col = colors(pd)

            if opts.duration? and opts.duration > 0
                if __type(opts.duration) == "function"
                    dur = opts.duration(pd)
                else
                    dur = opts.duration
                if opts.delay?
                    if __type(opts.delay) == 'function'
                        delay = opts.delay(pd)
                    else
                        delay = opts.delay
                else
                    delay = 0
                if path.svgPath.attrs['fill'] == "none"
                    ncol = colors(null)
                    path.svgPath.attr('fill',ncol)
                anim = Raphael.animation({fill: col}, dur)
                path.svgPath.animate(anim.delay(delay))
            else
                path.svgPath.attr('fill', col)
            #path.svgPath.node.setAttribute('style', 'fill:'+col)
    return


