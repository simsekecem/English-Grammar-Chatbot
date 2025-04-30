% Kişi ve sayı bilgileri
ozne(i, 1, tekil).
ozne(you, 2, tekil).
ozne(he, 3, tekil).
ozne(she, 3, tekil).
ozne(it, 3, tekil).
ozne(we, 1, cogul).
ozne(they, 3, cogul).


% Hatalı özneleri düzeltmek için
ozne_duzeltme(i, i).
ozne_duzeltme(you, you).
ozne_duzeltme(he, he).
ozne_duzeltme(she, she).
ozne_duzeltme(it, it).
ozne_duzeltme(we, we).
ozne_duzeltme(they, they).

ozne_duzeltme(me, i).
ozne_duzeltme(my, i).
ozne_duzeltme(mine, i).
ozne_duzeltme(her, she).
ozne_duzeltme(him, he).
ozne_duzeltme(us, we).
ozne_duzeltme(them, they).
ozne_duzeltme(our, we).
ozne_duzeltme(their, they).

% Geniş zaman (present) fiil çekimleri
fiil_zaman(go, 3, tekil, goes).
fiil_zaman(go, _, cogul, go).
fiil_zaman(go, 1, tekil, go).
fiil_zaman(go, 2, tekil, go).

fiil_zaman(play, 3, tekil, plays).
fiil_zaman(play, _, cogul, play).
fiil_zaman(play, 1, tekil, play).
fiil_zaman(play, 2, tekil, play).

fiil_zaman(eat, 3, tekil, eats).
fiil_zaman(eat, _, cogul, eat).
fiil_zaman(eat, 1, tekil, eat).
fiil_zaman(eat, 2, tekil, eat).

fiil_zaman(like, 3, tekil, likes).
fiil_zaman(like, _, cogul, like).
fiil_zaman(like, 1, tekil, like).
fiil_zaman(like, 2, tekil, like).

% Geniş zaman cümle doğrulama
cumle_dogrula(Ozne, FiilKokAtom, NesneStr, DogruCumle) :-
    atom_string(FiilKok, FiilKokAtom),
    ozne(Ozne, Kisi, Sayi),
    fiil_zaman(FiilKok, Kisi, Sayi, CekimliFiil),
    atomic_list_concat([Ozne, CekimliFiil, NesneStr], ' ', DogruCumle).

cumle_dogrula_geri_bildirim(OzneVerilen, FiilVerilen, NesneStr, FiilKokAtom, DogruCumle, GeriBildirim) :-
    atom_string(FiilKok, FiilKokAtom),
    ozne_duzeltme(OzneVerilen, OzneDuzeltildi),
    ozne(OzneDuzeltildi, Kisi, Sayi),
    fiil_zaman(FiilKok, Kisi, Sayi, DogruFiil),
    atomic_list_concat([OzneDuzeltildi, DogruFiil, NesneStr], ' ', DogruCumle),
    ( (FiilVerilen \= DogruFiil ; OzneVerilen \= OzneDuzeltildi) ->
        format(atom(GeriBildirim), '~n~w ~w yerine ~w ~w olmali.', 
            [OzneVerilen, FiilVerilen, OzneDuzeltildi, DogruFiil])
    ; 
        GeriBildirim = 'Cümle dogru gorunuyor.'
    ).

