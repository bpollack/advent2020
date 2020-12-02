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
    [ { [ all-unique? ] [ sum 2020 = ] } 1&& ] product-find
    1 [ * ] reduce ;

:: day1 ( -- )
    "vocab:advent/1.input" utf8 file-lines [ string>number ] map :> input
    { input input } find-2020-tuple .
    { input input input } find-2020-tuple . ;

:: day2 ( -- )
    "vocab:advent/2.input" utf8 file-lines :> input
    input [ [ password-validates-counts? ] password-line-validates? ] count .
    input [ [ password-validates-positions? ] password-line-validates? ] count . ;
