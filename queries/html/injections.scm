;; extends

; AlpineJS attributes
(attribute
    (attribute_name) @_attr
        (#lua-match? @_attr "^[@x][%-:]?%l")
    (quoted_attribute_value
        (attribute_value) @injection.content)
    (#set! injection.language "javascript"))

; _hyperscript attribute
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "_")
    (quoted_attribute_value
        (attribute_value) @injection.content)
    (#set! injection.language "hyperscript"))


; hx-vals attribute (using Javascript)
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "hx-vals")
    (quoted_attribute_value
        (attribute_value) @injection.content)
    (#set! injection.language "javascript"))
