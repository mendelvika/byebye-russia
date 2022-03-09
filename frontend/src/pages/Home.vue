<template>
  <main class="home-page" :class="{'events-none' : loading}">
    <section class="main-screen">
      <div class="main-screen__bg"></div>
      <h1 class="main-screen__title">
        <span>STOP WORKING</span>
        <span>WITH RUSSIA</span>
      </h1>
      <div class="news-line">
        <div class="news-line_top">
          <div class="news-line_top_left">
              <p class="support-tag">#standwithukraine</p>
          </div>
           <div class="news-line_top_right">
              <p>Business activity in Russia = support for putin’s regime.</p>
          </div>
        </div>
        <div class="news-line_btm">
           <div class="news-line_btm_left">
              <p class="date">
                <span class="day-date">{{ dayDate }}</span>
                <span class="time">{{ time }}</span>
              </p>
          </div>
           <div class="news-line_btm_right">
              <div class="brands-animation">
                <div class="brands-animation__item">BMW IKEA NIKE MCDONALDS CISCO FORMULA1 NETFLIX COURSERA</div>
                <div class="brands-animation__item">BMW IKEA NIKE MCDONALDS CISCO FORMULA1 NETFLIX COURSERA</div>
                <div class="brands-animation__item">BMW IKEA NIKE MCDONALDS CISCO FORMULA1 NETFLIX COURSERA</div>
              </div>
          </div>
        </div>
      </div>
    </section>
    <!-- <section class="about-project">
      <div class="about-project__wrapper">
        <div class="about-project__img">
          <img src="@/assets/images/russian-agression.jpeg" alt="russian agression" />
        </div>
        <div class="about-project__text">
          <h2></h2>
          <p></p>
        </div>
      </div>
    </section> -->
    <section class="brands-section">
      <div class="brands-section__wrapper">
        <div class="brands-section__sidebar">
          <div class="brands-section__sidebar__title">Filters</div>
          <div class="brands-section__categories">
            <div class="brands-section__categories__item" v-for="category in categories" :key="category.id">
              <div class="brands-section__categories__item__title" @click="fetchItemsInCategory(category)">
                {{category}}
              </div>
            </div>
          </div>
        </div>
        <div class="brands-section__cards">
          <div class="loader" :class="{'loader_open' : loading}">
            <div class="loader-spin"></div>
          </div>
          <div class="brands-section__cards__wrapper">
          <div class="brands-section__cards__item" v-for="brand in items" :key="brand.id">
            <a class="brands-section__cards__item__link" target="_blank" :href="brand.article != '' ? brand.article : ''">
              <div class="brands-section__cards__item__logo">
                <img :src="brand.logo" alt="ban-russia-brand" />
              </div>
              <div class="brands-section__cards__item__title">
                {{ brand.name }}
              </div>
             </a>
          </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<script>
import axios from 'axios'
export default {
  name: 'IndexPage',

  data () {
    return {
      count: 0,
      categories: [],
      items: [],
      interval: null,
      time: null,
      loading: false
    }
  },
  methods: {
    async fetchCountAndCategories () {
      await axios.get('https://api.byebye-russia.com/count')
        .then((response) => {
          this.count = response.data.count
          this.categories = response.data.categories
        })
        .catch((error) => {
          console.log(error)
        })
      await this.fetchItemsInCategory(this.categories[0])
    },
    
    async fetchItemsInCategory (category) {
      this.loading = true
      await axios.get('https://api.byebye-russia.com/companies/' + category)
        .then((response) => {
          this.items = response.data
          this.loading = false
        })
        .catch((error) => {
          this.loading = false
          console.log(error)
        })
    }
  },
  mounted () {
    this.fetchCountAndCategories()
  },
  computed: {
    dayDate: () => {
      return new Date().toLocaleDateString()
    }
  },
  beforeDestroy () {
    clearInterval(this.interval)
  },
  created () {
    this.interval = setInterval(() => {
      this.time = Intl.DateTimeFormat(navigator.language, {
        hour: 'numeric',
        minute: 'numeric',
        second: 'numeric'
      }).format()
    }, 1000)
  }
}
</script>
