// Accept HMR as per: https://vitejs.dev/guide/api-hmr.html
if (import.meta.hot) {
  import.meta.hot.accept(() => {
    console.log('HMR')
  })
}

import 'vite/modulepreload-polyfill'
import '../img/sprite.svg'
import Alpine from 'alpinejs'

window.Alpine = Alpine

Alpine.start()

console.log('Hello from app.ts')
