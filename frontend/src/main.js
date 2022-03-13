import Vue from 'vue'
import VueLazyload from 'vue-lazyload'
import AppLayout from './layout/index.vue'
import router from './router'
import store from './store'
import './scss/style.scss'

Vue.use(VueLazyload)

Vue.config.productionTip = false

new Vue({
  name: 'Root',
  router,
  store,
  render: h => h(AppLayout)
}).$mount('#app')
