IN: advent

USING: io io.files io.encodings.utf8
arrays assocs accessors combinators.short-circuit kernel
math math.order math.parser prettyprint
sequences sequences.product sets splitting ;

TUPLE: password-rule low high letter ;
C: <password-rule> password-rule

: parse-rule ( string -- password-rule )
    " -:" split first3
    [ [ string>number ] bi@ ] dip first <password-rule> ;

:: password-validates-counts? ( password rule -- t/f )
    password [ rule letter>> = ] count
    rule [ low>> ] [ high>> ] bi between? ;

:: password-validates-positions? ( password rule -- t/f )
    rule low>> 1 - password nth
    rule high>> 1 - password nth
    2array [ rule letter>> = ] count 1 = ;

: password-line-validates? ( line validator: ( password rule -- t/f ) -- t/f )
    [ " " split1-last swap parse-rule ] dip call( password rule -- t/f ) ;

: find-2020-tuple ( sequences -- pair )
    <product-sequence>
    [ { [ all-unique? ] [ sum 2020 = ] } 1&& ] find nip ;

: problem1 ( -- )
    "vocab:advent/1.input" utf8 file-lines
    [ string>number ] map    
    dup dup 2array find-2020-tuple .
    dup dup 3array find-2020-tuple . ;

: problem2 ( -- )
    "vocab:advent/2.input" utf8 file-lines
    dup
    [ [ password-validates-counts? ] password-line-validates? ] count .
    [ [ password-validates-positions? ] password-line-validates? ] count . ;
