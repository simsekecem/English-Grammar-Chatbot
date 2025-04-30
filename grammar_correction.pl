% Öznelere ait kişi ve sayı bilgisi
ozne(i, 1, tekil).
ozne(you, 2, tekil).
ozne(he, 3, tekil).
ozne(she, 3, tekil).
ozne(it, 3, tekil).
ozne(we, 1, cogul).
ozne(they, 3, cogul).

% Fiil çekimleri: fiil_kök, kişi, sayı, çekimli hali
fiil(go, 3, tekil, goes).
fiil(go, _, cogul, go).
fiil(go, 1, tekil, go).
fiil(go, 2, tekil, go).

fiil(play, 3, tekil, plays).
fiil(play, _, cogul, play).
fiil(play, 1, tekil, play).
fiil(play, 2, tekil, play).

fiil(eat, 3, tekil, eats).
fiil(eat, _, cogul, eat).
fiil(eat, 1, tekil, eat).
fiil(eat, 2, tekil, eat).

% Cümleyi doğrulayıp doğru halini üretir
cumle_dogrula(Ozne, FiilKok, Nesne, DogruCumle) :-
    ozne(Ozne, Kisi, Sayi),
    fiil(FiilKok, Kisi, Sayi, CekimliFiil),
    atomic_list_concat([Ozne, CekimliFiil, Nesne], ' ', DogruCumle).

% Yardımcı: yanlış cümledeki fiil hatasını düzeltip doğru halini verir
duzelt(CumleListesi, DogruCumle) :-
    CumleListesi = [Ozne, FiilKok | NesneListesi],
    atomic_list_concat(NesneListesi, ' ', Nesne),
    cumle_dogrula(Ozne, FiilKok, Nesne, DogruCumle).
