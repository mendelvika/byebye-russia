<template>
  <main class="home page">
    <section class="main-screen">
      <h1 class="main-screen__title">
        <span>STOP WORKING</span>
        <span>WITH RUSSIA</span>
      </h1>
      <p class="main-screen__undertitle">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      <!-- <div class="total-amount">
        <div class="total-amount__num"> {{count}} </div>
      </div> -->
    </section>
    <section class="brands-section">
      <div class="brands-section__wrapper">
        <div class="brands-section__sidebar">
          <div class="brands-section__sidebar__title">Filters</div>
          <div class="brands-section__categories">
            <div class="brands-section__categories__item" v-for="category in categories" :key="category.id">
              <!-- <div class="brands-section__categories__item__img">
                 <img alt="category-logo" />
              </div> -->
              <div class="brands-section__categories__item__title" @click="fetchItemsInCategory(category)">
                {{category}}
              </div>
            </div>
          </div>
        </div>
        <div class="brands-section__cards">
          <div class="brands-section__cards__item" v-for="brand in items" :key="brand.id">
            <a class="brands-section__cards__item__link" target="_blank" :href="brand.article">
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
    </section>
  </main>
</template>

<script>
// import companies from './companies.json'
import axios from 'axios'
export default {
  name: 'IndexPage',

  data () {
    return {
      count: 0,
      categories: [],
      items: []
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
      await axios.get('https://api.byebye-russia.com/companies/' + category)
        .then((response) => {
          this.items = response.data
        })
        .catch((error) => {
          console.log(error)
        })
    }
  },
  mounted () {
    this.fetchCountAndCategories()
  },
  computed: {
    filterBrandsByCategory: () => {
      return this.products.filter(product => !product.category.indexOf(this.category))
    }
  }
}
</script>
