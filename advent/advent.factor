IN: advent

USING: io io.files io.encodings.utf8
arrays assocs accessors combinators combinators.short-circuit kernel
hashtables regexp
math math.order math.parser math.vectors prettyprint
sequences sequences.extras sequences.product sets splitting ;

! Day 1
: find-2020-tuple ( sequences -- pair )
    [ { [ all-unique? ] [ sum 2020 = ] } 1&& ] product-find
    1 [ * ] reduce ;

:: day1 ( -- )
    "vocab:advent/1.input" utf8 file-lines [ string>number ] map :> input
    { input input } find-2020-tuple .
    { input input input } find-2020-tuple . ;


! Day 2
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

:: day2 ( -- )
    "vocab:advent/2.input" utf8 file-lines :> input
    input [ [ password-validates-counts? ] password-line-validates? ] count .
    input [ [ password-validates-positions? ] password-line-validates? ] count . ;

! Day 3
:: count-trees ( lines movement -- count )   
    lines { 0 0 } [| totals line |
        totals first2 :> trees :> pos
        pos movement + line length mod
        pos line nth CHAR: # = 1 0 ? trees +
        2array
    ] reduce last ;

:: day3 ( -- )
    "vocab:advent/3.input" utf8 file-lines :> input
    "Part A" .
    input 3 count-trees .
    "Part B" .
    V{ } clone :> acc
    input 1 count-trees acc push
    input 3 count-trees acc push
    input 5 count-trees acc push
    input 7 count-trees acc push
    input [ nip even? ] filter-index 1 count-trees acc push
    acc product . ;

: hashify-passport ( passport -- hashtable )
    " " split harvest [ ":" split harvest ] map >hashtable ;

: normalize-passports ( contents -- normalized )
    "\n\n" split-subseq [ "\n" " " replace hashify-passport ] map ;

: valid-height? ( height -- t/f )
    {
        { [ dup R/ \d+cm/ matches? ] [ 2 head* string>number 150 193 between? ] }
        { [ dup R/ \d+in/ matches? ] [ 2 head* string>number 59 76 between? ] }
        [ drop f ]
    } cond ;

: valid-passport? ( passport -- t/f )
    {
        [ "byr" of { [ dup [ R/ \d{4}/ matches? ] when ] [ string>number 1920 2002 between? ] } 1&& ]
        [ "iyr" of { [ dup [ R/ \d{4}/ matches? ] when ] [ string>number 2010 2020 between? ] } 1&& ]
        [ "eyr" of { [ dup [ R/ \d{4}/ matches? ] when ] [ string>number 2020 2030 between? ] } 1&& ]
        [ "hgt" of dup [ valid-height? ] when ]
        [ "hcl" of dup [ R/ #\p{xdigit}{6}/ matches? ] when ]
        [ "ecl" of { "amb" "blu" "brn" "gry" "grn" "hzl" "oth" } in? ]
        [ "pid" of dup [ R/ \d{9}/ matches? ] when ]
    } 1&& ;

: day4 ( -- )
    "vocab:advent/4.input" utf8 file-contents
    normalize-passports [ valid-passport? ] count . ;
