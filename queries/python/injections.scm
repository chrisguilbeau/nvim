; Inject SQL into Python strings assigned to a variable named "sql"
((expression_statement
   (assignment
     left: (identifier) @lhs
     right: (string (string_content) @injection.content)))
 (#eq? @lhs "sql")
 (#set! injection.language "sql"))
;; Match calls like: selectRows(sql='...')
;; and highlight the string as SQL.

((call
   arguments: (argument_list
                (keyword_argument
                  name: (identifier) @kwarg_name
                  value: (string (string_content) @injection.content)
                  )+
                )
   )
 (#eq? @kwarg_name "sql")
 (#set! injection.language "sql")
 (#set! injection.supertypes "string"))
