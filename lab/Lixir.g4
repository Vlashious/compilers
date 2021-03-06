grammar Lixir;

PRINT: 'print';
METHOD: 'meth';
IS: '.is';
ADD: '.add';
REMOVE: '.remove';
NAME_PROP: '.name';
VALUE_PROP: '.value';
HAS: '.has';
OPEN_METH: '.Open';
SAVE_METH: '.Save';

IF: 'if';
ELSE: 'else';
FOR: 'for';
IN: 'in';
RETURN: 'return';

DOCUMENT: 'Document';
NODE: 'Node';
ATTRIBUTE: 'Attribute';
STRING: 'String';
INT: 'Int';

SEMICOLON: ':';
OPEN_BRACKET: '(';
CLOSE_BRACKET: ')';
QUOTE: '"';
EQUALS: '=';
COMMA: ',';
DOUBLE_DOT: '..';

VALID_NAME: [A-Za-z][A-Za-z0-9]*;
VALID_INTEGER: [1-9][0-9]*;
STRING_LINE: '"' [A-Za-z0-9 .]* '"';

lixir_parser: code* EOF;

code
    : instruction
    | method
    ;

type
    : DOCUMENT
    | NODE
    | ATTRIBUTE
    | STRING
    | INT
    ;
    
type_literal
    : document_literal
    | node_literal
    | attribute_literal
    | string_literal
    | integer_literal
    ;

instruction
    : variable_declaration
    | conditional_instruction
    | loop_instruction
    | variable_manipulation
    | return_instruction
    | print_instruction
    ;

variable_declaration
    : VALID_NAME IS type_literal
    ;
    
variable_manipulation
    : VALID_NAME NAME_PROP EQUALS string_literal
    | VALID_NAME VALUE_PROP EQUALS (type_literal|VALID_NAME)
    | VALID_NAME ADD (VALID_NAME|type_literal)
    | VALID_NAME REMOVE (VALID_NAME|type_literal)
    | VALID_NAME OPEN_METH string_literal
    | VALID_NAME SAVE_METH string_literal
    | VALID_NAME EQUALS VALID_NAME  parameter*
    ;
    
parameter
    : integer_literal
    | string_literal
    | VALID_NAME
    ;
    
conditional_instruction
    : IF boolean_instruction SEMICOLON code_block (ELSE code_block)?
    ;
    
boolean_instruction
    : VALID_NAME HAS string_literal
    | VALID_NAME NAME_PROP EQUALS EQUALS string_literal
    ;
    
loop_instruction
    : FOR VALID_NAME IN range_operator SEMICOLON code_block
    | FOR VALID_NAME IN VALID_NAME SEMICOLON code_block
    ;
    
range_operator: integer_literal DOUBLE_DOT integer_literal;
    
return_instruction
    : RETURN type_literal
    | RETURN VALID_NAME
    ;

method
    : METHOD type VALID_NAME method_variable* SEMICOLON code_block;

method_variable
    : type SEMICOLON VALID_NAME
    ;

code_block: OPEN_BRACKET instruction* CLOSE_BRACKET;

document_literal:
    DOCUMENT SEMICOLON
    OPEN_BRACKET ((string_literal|VALID_NAME) EQUALS (type_literal|VALID_NAME))?
    (COMMA (string_literal|VALID_NAME) EQUALS (type_literal|VALID_NAME))* CLOSE_BRACKET;
    
node_literal:
    NODE SEMICOLON
    OPEN_BRACKET ((string_literal|VALID_NAME) EQUALS (type_literal|VALID_NAME))?
    (COMMA (string_literal|VALID_NAME) EQUALS (type_literal|VALID_NAME))* CLOSE_BRACKET;
    
attribute_literal:
    ATTRIBUTE SEMICOLON
    OPEN_BRACKET (string_literal|VALID_NAME) EQUALS (type_literal|VALID_NAME) CLOSE_BRACKET
    ;

integer_literal:
    VALID_INTEGER;
    
string_literal: 
    STRING_LINE;
    
print_instruction
    : PRINT string_literal
    ;

WS: [ \n\t\r] -> skip;