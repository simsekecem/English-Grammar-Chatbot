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
% To be fiili çekimleri
% -----------------------------
to_be_zaman(i, 1, tekil, am).
to_be_zaman(you, 2, tekil, are).
to_be_zaman(he, 3, tekil, is).
to_be_zaman(she, 3, tekil, is).
to_be_zaman(it, 3, tekil, is).
to_be_zaman(we, 1, cogul, are).
to_be_zaman(they, 3, cogul, are).

% -----------------------------
% To be cümle kontrolü
% -----------------------------
to_be_cumle_dogrula_geri_bildirim(OzneVerilen, ToBeVerilen, NesneStr, DogruCumle, GeriBildirim) :-
    ozne_duzeltme(OzneVerilen, OzneDuzeltildi),
    ozne(OzneDuzeltildi, Kisi, Sayi),
    to_be_zaman(OzneDuzeltildi, Kisi, Sayi, DogruToBe),
    atomic_list_concat([OzneDuzeltildi, DogruToBe, NesneStr], ' ', DogruCumle),
    ( (ToBeVerilen \= DogruToBe ; OzneVerilen \= OzneDuzeltildi) ->
        format(atom(GeriBildirim), '~w ~w yerine ~w ~w olmali.', [OzneVerilen, ToBeVerilen, OzneDuzeltildi, DogruToBe])
    ;
        GeriBildirim = 'Cümle dogru gorunuyor.'
    ).

% -----------------------------
% Fiil son harflerine göre kontrol (es kuralı)
% -----------------------------
ends_with(Atom, Ends) :-
    atom_chars(Atom, Chars),
    reverse(Chars, Rev),
    (   Rev = [X,Y|_] -> (X = 'h', Y = 'c'; X = 'h', Y = 's')  % ch, sh
    ;   Rev = [X|_], member(X, Ends)
    ).


% -----------------------------
% Fiil kökü ayıklama
% -----------------------------
fiil_koku_bul(Fiil, Kok) :-
    (   sub_atom(Fiil, _, 3, 0, "ies"),       % studies -> study
        sub_atom(Fiil, 0, _, 3, K),
        atom_concat(K, "y", Kok)
    ;   sub_atom(Fiil, _, 2, 0, "es"),        % goes -> go, fixes -> fix
        sub_atom(Fiil, 0, _, 2, Kok)
    ;   sub_atom(Fiil, _, 1, 0, "s"),         % eats -> eat
        sub_atom(Fiil, 0, _, 1, Kok)
    ;   Kok = Fiil                            % zaten kök
    ).



% -----------------------------
% Geniş zaman fiil çekimleri
% -----------------------------
% Örnek fiiller (manuel eklenenler dahil)
fiil_zaman(go, 3, tekil, goes).
fiil_zaman(go, 1, tekil, go).
fiil_zaman(go, 2, tekil, go).
fiil_zaman(go, _, cogul, go).


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

fiil_zaman(live, 3, tekil, lives).
fiil_zaman(live, _, cogul, live).
fiil_zaman(live, 1, tekil, live).
fiil_zaman(live, 2, tekil, live).

fiil_zaman(write, 3, tekil, writes).
fiil_zaman(write, _, cogul, write).
fiil_zaman(write, 1, tekil, write).
fiil_zaman(write, 2, tekil, write).

fiil_zaman(study, 3, tekil, studies).
fiil_zaman(study, _, cogul, study).
fiil_zaman(study, 1, tekil, study).
fiil_zaman(study, 2, tekil, study).



% -----------------------------
% Doğru cümle oluşturma
% -----------------------------
cumle_dogrula(Ozne, FiilKokAtom, NesneStr, DogruCumle) :-
    FiilKok = FiilKokAtom,
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
        format(atom(GeriBildirim), '~w ~w yerine ~w ~w olmali.', [OzneVerilen, FiilVerilen, OzneDuzeltildi, DogruFiil])
    ;
        GeriBildirim = 'Cümle dogru gorunuyor.'
    ).


