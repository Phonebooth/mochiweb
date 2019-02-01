-module(mochiweb_request_tests).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

accepts_content_type_test() ->
    Req1 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "multipart/related"}])),
    ?assertEqual(true, mochiweb_request:accepts_content_type("multipart/related", Req1)),

    Req2 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html"}])),
    ?assertEqual(false, mochiweb_request:accepts_content_type("multipart/related", Req2)),

    Req3 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html, multipart/*"}])),
    ?assertEqual(true, mochiweb_request:accepts_content_type("multipart/related", Req3)),

    Req4 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html, multipart/*; q=0.0"}])),
    ?assertEqual(false, mochiweb_request:accepts_content_type("multipart/related", Req4)),

    Req5 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html, multipart/*; q=0"}])),
    ?assertEqual(false, mochiweb_request:accepts_content_type("multipart/related", Req5)),

    Req6 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html, */*; q=0.0"}])),
    ?assertEqual(false, mochiweb_request:accepts_content_type("multipart/related", Req6)),

    Req7 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "multipart/*; q=0.0, */*"}])),
    ?assertEqual(false, mochiweb_request:accepts_content_type("multipart/related", Req7)),

    Req8 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "*/*; q=0.0, multipart/*"}])),
    ?assertEqual(true, mochiweb_request:accepts_content_type("multipart/related", Req8)),

    Req9 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "*/*; q=0.0, multipart/related"}])),
    ?assertEqual(true, mochiweb_request:accepts_content_type("multipart/related", Req9)),

    Req10 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html; level=1"}])),
    ?assertEqual(true, mochiweb_request:accepts_content_type("text/html;level=1", Req10)),

    Req11 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html; level=1, text/html"}])),
    ?assertEqual(true, mochiweb_request:accepts_content_type("text/html", Req11)),

    Req12 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html; level=1; q=0.0, text/html"}])),
    ?assertEqual(false, mochiweb_request:accepts_content_type("text/html;level=1", Req12)),

    Req13 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html; level=1; q=0.0, text/html"}])),
    ?assertEqual(false, mochiweb_request:accepts_content_type("text/html; level=1", Req13)),

    Req14 = mochiweb_request:new(nil, 'GET', "/foo", {1, 1},
        mochiweb_headers:make([{"Accept", "text/html;level=1;q=0.1, text/html"}])),
    ?assertEqual(true, mochiweb_request:accepts_content_type("text/html; level=1", Req14)).

-endif.
