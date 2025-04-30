% Kişi ve sayı bilgileri
ozne(i, 1, tekil).
ozne(you, 2, tekil).
ozne(he, 3, tekil).
ozne(she, 3, tekil).
ozne(it, 3, tekil).
ozne(we, 1, cogul).
ozne(they, 3, cogul).

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

% Geniş zaman cümle doğrulama
cumle_dogrula(Ozne, FiilKokAtom, NesneStr, DogruCumle) :-
    atom_string(FiilKok, FiilKokAtom),
    ozne(Ozne, Kisi, Sayi),
    fiil_zaman(FiilKok, Kisi, Sayi, CekimliFiil),
    atomic_list_concat([Ozne, CekimliFiil, NesneStr], ' ', DogruCumle).

% Geri bildirimli kontrol
cumle_dogrula_geri_bildirim(Ozne, FiilVerilen, NesneStr, FiilKokAtom, DogruCumle, GeriBildirim) :-
    atom_string(FiilKok, FiilKokAtom),
    ozne(Ozne, Kisi, Sayi),
    fiil_zaman(FiilKok, Kisi, Sayi, DogruFiil),
    atomic_list_concat([Ozne, DogruFiil, NesneStr], ' ', DogruCumle),
    (FiilVerilen \= DogruFiil ->
        format(atom(GeriBildirim), 'Fiil "~w" hatalı, doğrusu "~w" olmalı.', [FiilVerilen, DogruFiil])
    ; 
        GeriBildirim = 'Cümle doğru görünüyor.'
    ).
