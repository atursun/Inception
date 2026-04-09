# Notlar

1. Sanallaştırma:
Sanal makineler, Fiziksel bir bilgisayar üzerinde kurulan sanal makinelerdir/ortamdır.
Bu sanal ortamlar tamamen izole bir şekilde çalışarak fiziksel makinenin donanımlarını (CPU,RAM, vb.) kullanır. sanal makineler fiziksel makineyi taklit eder. yani bilgisayarın için de kurduğumuz bilgisayardır. her sanal ortamın farklı bir işletim sistemi, dosya yapısı olabilir. Bir sanal ortamda yapılan değişiklik diğer sanal makineleri veya ana bilgisayarı etkilemez. bir sanal makine çökerse diğerleri çökmez. çünkü izole bir şekilde çalışır. yani, fiziksel makineden bağımsız çalışıyorlar. Sanal makine kullanmamızın sebebi ise, farklı işletim sistemleri denemek istiyorsak, yada güvenlik amacıyla dosyaları/programları ana cihazda değil de sanal ortamda açmak istiyorsak. Sanal makineler, Hypervisor denilen ana bilgisayarın donanımını sanal makinelere dağıtarak her birinin bağımsız ve izole şekilde çalışmasını sağlar. Sanal Makinenin amacı ise, Bir fiziksel sunucunun/bilgisayarın işlemci gücü, bellek kapasitesi ve depolama alanı gibi kaynakları genelde tam kapasite kullanılmaz. Sanal makineler, bu kaynakları bölerek birden fazla görev için kullanılabilir hale getirir. Sonuç; Tek bir fiziksel sunucunun kaynaklarını verimli bir şekilde birden fazla göreve bölersiniz. Böylece, hem maliyet düşer hem de verim artar.

2. ISO Dosyası:
bir disk veya işletim sisteminin dijital kopyasıdır. İçerisinde işletim sisteminin dosyaları, kurulum verileri, sistem dosyaları ve genellikle önyükleme için gerekli dosyalar bulunur. Bu, bir CD, DVD (Veri Depolama) veya USB'ye yazılarak fiziksel bir disk gibi kullanılabilir.

3. Vm **skip unattended installation**:
Bu seçeneği seçmek, otomatik kurulum adımlarını atlamayı sağlar.
Bu durumda kurulum manuel olarak yapılır.
Kullanıcı her adımı kendisi seçer ve onaylar.
Böylece hangi paketlerin ve ayarların kurulacağını kontrol edebilirsin.

4. Hard Disk File Type and Variant:
- Sanal Disk Türü -> Sanal makinede disk oluştururken seçtiğin dosya formatıdır.
    - VDI (VirtualBox Disk Image) → VirtualBox’a özel, esnek ve değiştirilebilir.
- Disk Tipi -> Diskin gerçek diske nasıl kaydedileceğini belirler
    - Dynamically allocated (Dinamik) → Disk büyüdükçe yer kaplar, başta az yer kullanır.
    - Fixed size (Sabit boyut) → Disk başta belirlenen boyutta yer kaplar, biraz daha hızlı.

5. Hostname && Domain Name:
- Hostname → Sanal makinenin/Cihazın/Bilgisayarın kendi adıdır.
Domain name → bir bilgisayarın veya servisin ağ üzerinde tanınmasını sağlayan isimdir.
Örneğin web sitelerinde **example.com** gibi yazılır.

6. Partition Disk:
Diskin mantıksal parçalara ayrılmasıdır. yani belirlediğin pathlere (root: 20GB, home: 5GB) şeklinde ayırmandır. Bu manuel seçeneğidir. eğer *use entire disk* dersen kurulum disk bölümleri kurulum tarafından oluşturulur.

7. GRUB Boot Loader:
GRUB, Linux’un açılmasını sağlayan önyükleyici yazılımdır. Debian kurulumunda GRUB’u yükleyerek VM’in hangi işletim sistemini başlatacağını belirledin. “sda” seçerek, GRUB’u sanal diskin ana alanına (MBR) yükledin. Bu sayede VM açıldığında otomatik olarak Debian başlatılacak. Eğer GRUB kurulmazsa, VM açıldığında işletim sistemi yüklenemez ve hata verir.

8. Snapshot:
Yani işletim sistemi, dosyalar, ayarlar ve programlar tam olarak o anki şekilde kaydedilir.
Eğer sonra bir şeyler bozulursa veya yanlış bir şey yaparsan, snapshot’ı geri yükleyerek VM’yi o ana geri alabilirsin.
Gerçek hayatta bir “fotoğraf” gibi düşünebilirsin, her şeyi dondurur ve istediğinde tekrar açabilirsin.