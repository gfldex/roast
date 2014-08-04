use v6;

use Test;

plan 88;

# L<S32::Str/Str/=item substr>

{ # read only
    my $str = "foobar";

    is(substr($str, 0, 0), '', 'Empty string with 0 as thrid arg');
    is(substr($str, 3, 0), '', 'Empty string with 0 as thrid arg');
    is(substr($str, 0, 1), "f", "first char");
    is(substr($str, *-1), "r", "last char");
    is(substr($str, *-4, 2), "ob", "counted from the end");
    is(substr($str, 1, 2), "oo", "arbitrary middle");
    is(substr($str, 3), "bar", "length omitted");
    is(substr($str, 3, 10), "bar", "length goes past end");
    ok(!defined(substr($str, 20, 5)), "substr outside of string");
    ok(!defined(substr($str, *-100, 10)), "... on the negative side");

    is(substr($str, 0, *-2), "foob", "from beginning, with negative length");
    is(substr($str, 2, *-2), "ob", "in middle, with negative length");
    is(substr($str, 3, *-3), "", "negative length - gives empty string");
    is(substr($str, *-4, *-1), "oba", "start from the end and negative length");

    is($str, "foobar", "original string still not changed");
};

{ # misc
    my $str = "hello foo and bar";
    is(substr($str, 6, 3), "foo", "substr");
    is($str.substr(6, 3), "foo", ".substr");
    is(substr("hello foo bar", 6, 3), "foo", "substr on literal string");
    is("hello foo bar".substr(6, 3), "foo", ".substr on literal string");
    is("hello foo bar".substr(6, 3).uc, "FOO", ".substr.uc on literal string");
    is("hello foo bar and baz".substr(6, 10).wordcase, "Foo Bar An", ".substr.wordcase on literal string");
    is("hello »« foo".substr(6, 2), "»«", ".substr on unicode string");
    is("שיעבוד כבר".substr(4, 4), "וד כ", ".substr on Hebrew text");
}

#?rakudo.jvm skip 'java.nio.charset.MalformedInputException'
{ # codepoints greater than 0xFFFF
    my $str = join '', 0x10426.chr, 0x10427.chr;
    is $str.codes, 2, "Sanity check string";
    #?niecza 2 todo "substr bug"
    is substr($str, 0, 1), 0x10426.chr, "Taking first char of Deseret string";
    is substr($str, 1, 1), 0x10427.chr, "Taking second char of Deseret string";
}

sub l (Int $a) {  my $l = $a; return $l }

#Substr with StrLen
{ # read only
    my $str = "foobar";

    is(substr($str, 0, l(0)), '', 'Empty string with 0 as thrid arg (substr(Int, StrLen)).');
    is(substr($str, 3, l(0)), '', 'Empty string with 0 as thrid arg (substr(Int, StrLen)).');
    is(substr($str, 0, l(1)), "f", "first char (substr(Int, StrLen)).");
    is(substr($str, *-1, l(1)), "r", "last char (substr(Int, StrLen)).");
    is(substr($str, *-4, l(2)), "ob", "counted from the end (substr(Int, StrLen)).");
    is(substr($str, 1, l(2)), "oo", "arbitrary middle (substr(Int, StrLen)).");
    is(substr($str, 3, l(6)), "bar", "length goes past end (substr(Int, StrLen)).");
    ok(!defined(substr($str, 20, l(5))), "substr outside of string (substr(Int, StrLen)).");
    ok(!defined(substr($str, *-100, l(5))), "... on the negative side (substr(Int, StrLen)).");

    is($str, "foobar", "original string still not changed (substr(Int, StrLen)).");
};

#?rakudo skip 'too many args'
{ # replacement
    my $str = "foobar";

    substr($str, 2, l(1), "i");
    is($str, "foibar", "fourth arg to substr replaced part (substr(Int, StrLen)).");

    substr($str, *-1, l(1), "blah");
    is($str, "foibablah", "longer replacement expands string (substr(Int, StrLen)).");

    substr($str, 1, l(3), "");
    is($str, "fablah", "shorter replacement shrunk it (substr(Int, StrLen)).");
};


{ # misc
    my $str = "hello foo and bar";

    is(substr($str, 6, l(3)), "foo", "substr (substr(Int, StrLen)).");
    is($str.substr(6, l(3)), "foo", ".substr (substr(Int, StrLen)).");
    is(substr("hello foo bar", 6, l(3)), "foo", "substr on literal string (substr(Int, StrLen)).");
    is("hello foo bar".substr(6, l(3)), "foo", ".substr on literal string (substr(Int, StrLen)).");
    is("hello foo bar".substr(6, l(3)).uc, "FOO", ".substr.uc on literal string (substr(Int, StrLen)).");
    is("hello foo bar and baz".substr(6, l(10)).wordcase, "Foo Bar An", ".substr.wordcase on literal string (substr(Int, StrLen)).");
    is("hello »« foo".substr(6, l(2)), "»«", ".substr on unicode string (substr(Int, StrLen)).");
    is("שיעבוד כבר".substr(4, l(4)), "וד כ", ".substr on Hebrew text (substr(Int, StrLen)).");
}

sub p (Int $a) {  my $p = $a; return $p }

#Substr with StrPos
#?rakudo skip 'StrPos NYI'
#?niecza skip 'StrPos tests broken'
{ # read only
    my $str = "foobar";
    is(substr($str, 0, p(0)), '', 'Empty string with 0 as thrid arg (substr(Int, StrPos)).');
    is(substr($str, 3, p(3)), '', 'Empty string with 0 as thrid arg (substr(Int, StrPos)).');
    is(substr($str, 0, p(1)), "f", "first char (substr(Int, StrPos)).");

    is(substr($str, 1, p(3)), "oo", "arbitrary middle (substr(Int, StrPos)).");
    is(substr("IMAGINATIVE => Insane Mimicries of Amazingly Gorgeous, Incomplete Networks, Axiomatic Theorems, and Immortally Vivacious Ecstasy", 1, p(2)), "MA", "substr works with named argument (substr(Int, StrPos)).");
    is(substr($str, 3, p(6)), "bar", "length goes past end (substr(Int, StrPos)).");
    ok(!defined(substr($str, 20, p(5))), "substr outside of string (substr(Int, StrPos)).");
    ok(!defined(substr($str, *-100, p(5))), "... on the negative side (substr(Int, StrPos)).");

    is($str, "foobar", "original string still not changed (substr(Int, StrPos)).");
};

#?rakudo skip 'StrPos NYI'
#?niecza skip 'StrPos tests broken'
{ # replacement
    my $str = "foobar";
    substr($str, 2, p(1), "i");
    is($str, "foibar", "fourth arg to substr replaced part (substr(Int, StrPos)).");

    substr($str, 2, p(1), "a");
    is($str, "foabar", "substr with replacement works with named argument (substr(Int, StrPos)).");

    substr($str, *-1, p(1), "blah");
    is($str, "foibablah", "longer replacement expands string (substr(Int, StrPos)).");

    substr($str, 1, p(3), "");
    is($str, "fablah", "shorter replacement shrunk it (substr(Int, StrPos)).");
};

# as lvalue, XXX: not sure this should work, as that'd be action at distance:
#   my $substr = \substr($str, ...);
#   ...;
#   some_func $substr; # manipulates $substr
#   # $str altered!
# But one could think that's the wanted behaviour, so I leave the test in.
#?rakudo skip 'StrPos NYI'
#?niecza skip 'StrPos tests broken'
{
    my $str = "gorch ding";

    substr($str, 0, p(5)) = "gloop";
    is($str, "gloop ding", "lvalue assignment modified original string (substr(Int, StrPos)).");

    my $r = \substr($str, 0, p(5));
    ok(WHAT($r).gist, '$r is a reference (substr(Int, StrPos)).');
    is($$r, "gloop", '$r referent is eq to the substring (substr(Int, StrPos)).');

    $$r = "boing";
    is($str, "boing ding", "assignment to reference modifies original (substr(Int, StrPos)).");
    is($$r, "boing", '$r is consistent (substr(Int, StrPos)).');

    my $o = \substr($str, 3, p(2));
    is($$o, "ng", "other ref to other lvalue (substr(Int, StrPos)).");
    $$r = "foo";
    is($str, "foo ding", "lvalue ref size varies but still works (substr(Int, StrPos)).");
    is($$o, " d", "other lvalue wiggled around (substr(Int, StrPos)).");

};

#?rakudo skip 'lvalue substr'
#?niecza skip 'StrPos tests broken'
{ # as lvalue, should work
    my $str = "gorch ding";

    substr($str, 0, p(5)) = "gloop";
    is($str, "gloop ding", "lvalue assignment modified original string (substr(Int, StrPos)).");
};

#?rakudo skip 'StrPos NYI'
#?niecza skip 'StrPos tests broken'
{ # as lvalue, using :=, should work
    my $str = "gorch ding";

    substr($str, 0, p(5)) = "gloop";
    is($str, "gloop ding", "lvalue assignment modified original string (substr(Int, StrPos)).");

    my $r := substr($str, 0, p(5));
    is($r, "gloop", 'bound $r is eq to the substring (substr(Int, StrPos)).');

    $r = "boing";
    is($str, "boing ding", "assignment to bound var modifies original (substr(Int, StrPos)).");
    is($r, "boing", 'bound $r is consistent (substr(Int, StrPos)).');

    my $o := substr($str, 3, p(2));
    is($o, "ng", "other bound var to other lvalue (substr(Int, StrPos)).");
    $r = "foo";
    is($str, "foo ding", "lvalue ref size varies but still works (substr(Int, StrPos)).");
    is($o, " d", "other lvalue wiggled around (substr(Int, StrPos)).");
};

{ # misc
    my $str = "hello foo and bar";
    is(substr($str, 6, p(3)), "foo", "substr (substr(Int, StrPos)).");
    is($str.substr(6, p(3)), "foo", ".substr (substr(Int, StrPos)).");
    is(substr("hello foo bar", 6, p(3)), "foo", "substr on literal string (substr(Int, StrPos)).");
    is("hello foo bar".substr(6, p(3)), "foo", ".substr on literal string (substr(Int, StrPos)).");
    is("hello foo bar".substr(6, p(3)).uc, "FOO", ".substr.uc on literal string (substr(Int, StrPos)).");
    is("hello foo bar and baz".substr(6, p(10)).wordcase, "Foo Bar An", ".substr.wordcase on literal string (substr(Int, StrPos)).");
    is("hello »« foo".substr(6, p(2)), "»«", ".substr on unicode string (substr(Int, StrPos)).");
    is("שיעבוד כבר".substr(4, p(4)), "וד כ", ".substr on Hebrew text (substr(Int, StrPos)).");
}

#?niecza todo
eval_dies_ok 'substr(Any, 0)', 'substr needs Cool as argument';

# RT 76682
#?niecza skip "'Failure' used at line 244"
{
    is "foo".substr(4), Failure, 'substr with start beyond end of string is Failure'
}

# RT 115086
#?niecza todo
{
    is "abcd".substr(2, Inf), 'cd', 'substr to Inf'
}

{
    is 123456789.substr(*-3), '789', 'substr with Int and WhateverCode arg';

}

# vim: ft=perl6
