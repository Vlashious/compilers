grammar Lixir;


METHOD: 'meth';
IS: '.is';
NAME_PROP: '.name';
VALUE_PROP: '.value';
OPEN_METH: '.Open';
SAVE_METH: '.Save';
RETURN: 'return';

DOCUMENT: 'Document';
NODE: 'Node';
ATTRIBUTE: 'Attribute';
STRING: 'String';
INT: 'Int';

SEMICOLON: ':';
OPEN_BRACKET: '(';
CLOSE_BRACKET: ')';
VALID_NAME: [A-Za-z][A-Za-z0-9]*;
VALID_INTEGER: [1-9][0-9]*;
QUOTE: '"';
EQUALS: '=';
COMMA: ',';

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
    | string_literal
    | integer_literal
    ;

instruction
    : variable_declaration
    | return_instruction
    ;

variable_declaration
    : VALID_NAME IS type_literal
    | VALID_NAME IS VALID_NAME OPEN_BRACKET CLOSE_BRACKET
    ;
    
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
    OPEN_BRACKET (string_literal EQUALS type_literal)?
    (COMMA string_literal EQUALS type_literal)* CLOSE_BRACKET;
    
node_literal:
    NODE SEMICOLON
    OPEN_BRACKET (string_literal EQUALS type_literal)?
    (COMMA string_literal EQUALS type_literal)* CLOSE_BRACKET;

integer_literal:
    VALID_INTEGER;
    
string_literal: 
    QUOTE VALID_NAME QUOTE;

WS: [ \n\t\r] -> skip;