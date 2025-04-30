from pyswip import Prolog

# Prolog dosyasını yükle
prolog = Prolog()
prolog.consult("grammar_correction.pl")  # Dosya adını kendi .pl dosyana göre ayarla

print("📘 Gramer Düzeltici Chatbot (Çıkmak için 'exit' yaz)\n")

while True:
    cumle = input("👤 Sen: ").lower()
    if cumle.strip() in ['exit', 'quit', 'çık']:
        print("👋 Görüşmek üzere!")
        break

    # Kullanıcının cümlesini parçala
    kelimeler = cumle.split()
    
    # Yeterli uzunlukta mı kontrol et kontrol deneme
    if len(kelimeler) < 3:
        print("⚠️ Lütfen en az bir özne, fiil ve nesne gir.")
        continue

    ozne, fiil, *nesne = kelimeler
    nesne_str = ' '.join(nesne)

    # Prolog sorgusunu hazırla
    query = f"cumle_dogrula({ozne}, {fiil}, '{nesne_str}', C)."

    try:
        sonuc = list(prolog.query(query))
        if sonuc:
            print("✅ Doğru hali:", sonuc[0]["C"])
        else:
            print("❌ Bu cümle için kural bulunamadı.")
    except Exception as e:
        print("⚠️ Hatalı giriş veya Prolog hatası:", e)
