IN: advent

USING: io io.files io.encodings.utf8
arrays combinators.short-circuit kernel math.parser prettyprint
sequences sequences.product sets ;

: find-2020-tuple ( sequences -- pair )
    <product-sequence>
    [ { [ all-unique? ] [ sum 2020 = ] } 1&& ] find nip ;

: problem1 ( seqs -- tuple )
    "vocab:advent/1.input" utf8 [ lines ] with-file-reader
    [ string>number ] map    
    dup dup 2array find-2020-tuple .
    dup dup 3array find-2020-tuple . ;
