# Maintainer: Jordan Lord <me@jordanlord.co.uk>
pkgname=pomodoro
pkgver=1.0.0
pkgrel=1
pkgdesc="Pomodoro timer"
arch=('any')
url=""
license=('unknown')
depends=()
source=(
    './pomodoro.sh'
    './sample-config.txt'
)
md5sums=(
    'SKIP'
    'SKIP'
)

package() {
    install -Dm755 pomodoro.sh "$pkgdir/usr/bin/pomodoro"

    install -d "$pkgdir/etc/pomodoro"

    install -Dm644 sample-config.txt "$pkgdir/etc/pomodoro/config.txt.pacnew"
}
