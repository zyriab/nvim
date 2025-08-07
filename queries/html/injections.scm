;; extends

; AlpineJS attributes
(attribute
    (attribute_name) @_attr
        (#lua-match? @_attr "^[@x][%-:]?%l")
    (quoted_attribute_value
        (attribute_value) @injection.content)
    (#set! injection.language "javascript"))

; hx-vals attribute (using Javascript)
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "hx-vals")
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

; _hyperscript attribute in Go's `fmt.Sprintf` (quotes)
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "_")
    (expression
        (call_expression
            function: (selector_expression
                operand: (identifier) @_fmt
                field: (field_identifier) @_sprintf)
            arguments: (argument_list
                (interpreted_string_literal
                    (interpreted_string_literal_content) @injection.content))))
    (#eq? @_fmt "fmt")
    (#eq? @_sprintf "Sprintf")
    (#set! injection.language "hyperscript"))

; _hyperscript attribute in Go's `fmt.Sprintf` (backticks)
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "_")
    (expression
        (call_expression
            function: (selector_expression
                operand: (identifier) @_fmt
                field: (field_identifier) @_sprintf)
            arguments: (argument_list
                (raw_string_literal
                    (raw_string_literal_content) @injection.content))))
    (#eq? @_fmt "fmt")
    (#eq? @_sprintf "Sprintf")
    (#set! injection.language "hyperscript"))

; HS field with fmt.Sprintf (quotes)
(keyed_element
    key: (literal_element
        (identifier) @_key)
    value: (literal_element
        (call_expression
            function: (selector_expression
                operand: (identifier) @_fmt
                field: (field_identifier) @_sprintf)
            arguments: (argument_list
                (interpreted_string_literal
                    (interpreted_string_literal_content) @injection.content))))
    (#eq? @_key "HS")
    (#eq? @_fmt "fmt")
    (#eq? @_sprintf "Sprintf")
    (#set! injection.language "hyperscript"))

; HS field with fmt.Sprintf (backticks)
(keyed_element
    key: (literal_element
        (identifier) @_key)
    value: (literal_element
        (call_expression
            function: (selector_expression
                operand: (identifier) @_fmt
                field: (field_identifier) @_sprintf)
            arguments: (argument_list
                (raw_string_literal
                    (raw_string_literal_content) @injection.content))))
    (#eq? @_key "HS")
    (#eq? @_fmt "fmt")
    (#eq? @_sprintf "Sprintf")
    (#set! injection.language "hyperscript"))

; HS field with interpreted string literal (quotes)
(keyed_element
    key: (literal_element
        (identifier) @_key)
    value: (literal_element
        (interpreted_string_literal
            (interpreted_string_literal_content) @injection.content))
    (#eq? @_key "HS")
    (#set! injection.language "hyperscript"))

; HS field with raw string literal (backticks)
(keyed_element
    key: (literal_element
        (identifier) @_key)
    value: (literal_element
        (raw_string_literal
            (raw_string_literal_content) @injection.content))
    (#eq? @_key "HS")
    (#set! injection.language "hyperscript"))

