% -----------------------------
% Özne bilgileri (kişi ve sayı)
% -----------------------------
ozne(i, 1, tekil).
ozne(you, 2, tekil).
ozne(he, 3, tekil).
ozne(she, 3, tekil).
ozne(it, 3, tekil).
ozne(we, 1, cogul).
ozne(they, 3, cogul).

% -----------------------------
% Hatalı özneleri düzeltme
% -----------------------------
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
ozne_duzeltme(his, he).
ozne_duzeltme(us, we).
ozne_duzeltme(them, they).
ozne_duzeltme(our, we).
ozne_duzeltme(their, they).

% -----------------------------
% Fiil kökü ayıklama
% -----------------------------
fiil_koku_bul(Fiil, Kok) :-
    atom_chars(Fiil, Chars),
    (   append(KokList, ['e','s'], Chars), KokList \= [] -> true
    ;   append(KokList, ['s'], Chars), KokList \= [] -> true
    ;   KokList = Chars),
    atom_chars(Kok, KokList), !.

% -----------------------------
% Geniş zaman fiil çekimleri
% -----------------------------
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

% -----------------------------
% Doğru cümle oluşturma
% -----------------------------
cumle_dogrula(Ozne, FiilKokAtom, NesneStr, DogruCumle) :-
    atom_string(FiilKok, FiilKokAtom),
    ozne(Ozne, Kisi, Sayi),
    fiil_zaman(FiilKok, Kisi, Sayi, CekimliFiil),
    atomic_list_concat([Ozne, CekimliFiil, NesneStr], ' ', DogruCumle).

% -----------------------------
% Cümleyi kontrol edip düzeltme ve geri bildirim
% -----------------------------
cumle_dogrula_geri_bildirim(OzneVerilen, FiilVerilen, NesneStr, DogruCumle, GeriBildirim) :-
    ozne_duzeltme(OzneVerilen, OzneDuzeltildi),
    fiil_koku_bul(FiilVerilen, FiilKok),
    ozne(OzneDuzeltildi, Kisi, Sayi),
    fiil_zaman(FiilKok, Kisi, Sayi, DogruFiil),
    atomic_list_concat([OzneDuzeltildi, DogruFiil, NesneStr], ' ', DogruCumle),
    ( (FiilVerilen \= DogruFiil ; OzneVerilen \= OzneDuzeltildi) ->
        format(atom(GeriBildirim), '~w ~w yerine ~w ~w olmali.',
            [OzneVerilen, FiilVerilen, OzneDuzeltildi, DogruFiil])
    ;
        GeriBildirim = 'Cümle dogru gorunuyor.'
    ).
