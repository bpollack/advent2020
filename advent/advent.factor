IN: advent

USING: io io.files io.encodings.utf8
arrays assocs accessors combinators.short-circuit kernel
math math.order math.parser prettyprint
sequences sequences.product sets splitting ;

! This is a bit wrong, because part two changed the slot meanings, but
! it's clearer than num1 and num2 or something
TUPLE: password-rule minimum maximum letter ;
C: <password-rule> password-rule

: parse-rule ( string -- password-rule )
    " " split1 first
    [ "-" split1 [ string>number ] bi@ ] dip
    <password-rule> ;

:: password-validates-a? ( password rule -- t/f )
    password [ rule letter>> = ] count
    rule [ minimum>> ] [ maximum>> ] bi between? ;

:: password-validates-b? ( password rule -- t/f )
    rule minimum>> 1 - password nth
    rule maximum>> 1 - password nth
    2array [ rule letter>> = ] count 1 = ;

: password-line-validates? ( line validator: ( password rule -- t/f ) -- t/f )
    [ " " split1-last swap parse-rule ] dip call( password rule -- t/f ) ;

: find-2020-tuple ( sequences -- pair )
    <product-sequence>
    [ { [ all-unique? ] [ sum 2020 = ] } 1&& ] find nip ;

: problem1 ( -- )
    "vocab:advent/1.input" utf8 [ lines ] with-file-reader
    [ string>number ] map    
    dup dup 2array find-2020-tuple .
    dup dup 3array find-2020-tuple . ;

: problem2 ( -- )
    "vocab:advent/2.input" utf8 [ lines ] with-file-reader
    dup
    [ [ password-validates-a? ] password-line-validates? ] count .
    [ [ password-validates-b? ] password-line-validates? ] count . ;
