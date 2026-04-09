42-Curses/ reposuna submodel olarak ekledin bunu
o yüzden proje bittikten sonrasında güncelle
Komutlar:
# Submodule ekleme
git submodule add <repository-url> <path>

# Submodule'leri güncelleme
git submodule update --init --recursive

# Submodule'leri en son versiyona çekme
git submodule update --remote

# Submodule silme
git submodule deinit <path>
git rm <path>