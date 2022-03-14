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
              <p>Business activity in Russia will be perceived as support for putin’s regime</p>
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
                <div class="brands-animation__item">BMW IKEA NIKE MCDONALDS CISCO FORMULA1 NETFLIX COURSERA Apple Louis Vuitton AMD Puma Oracle American Express Dior UBISOFT Victoria's Secret Upwork Porsche Azur Air Vogue Mothercare PayPal Sony Sephora BBC Shell</div>
                <div class="brands-animation__item">BMW IKEA NIKE MCDONALDS CISCO FORMULA1 NETFLIX COURSERA</div>
                <div class="brands-animation__item">BMW IKEA NIKE MCDONALDS CISCO FORMULA1 NETFLIX COURSERA</div>
              </div>
          </div>
        </div>
      </div>
    </section>
    <section class="about-project">
      <div class="about-project__wrapper">
        <div class="about-project__img">
          <img src="@/assets/images/russian-agression.jpeg" alt="russian agression" />
        </div>
        <div class="about-project__text">
          <div class="about-project__text__header">
            <div class="count">{{count}}</div>
            <h2> brands in various industries throughout the globe have already stopped working in Russia and joined the protest to support Ukraine. </h2>
          </div>
          <p>On 24th of February at 5 am, Russia invaded Ukraine, bombarding its peaceful cities. It is the largest conventional military attack in Europe since <a target="_blank" href="https://edition.cnn.com/2022/02/24/politics/us-military-ukraine-russia/index.html"> World War II</a>.</p>
          <p>The products you created should not be used in the country, which tries to deprive Ukraine of its freedom and democracy. </p>
          <p>We call on your company to end any existing relationships and stop doing business in russia until the russian aggression in Ukraine is fully stopped, and fair order is restored. </p>
          <p class="marked marked_bold">Every ruble paid in taxes to russia turns into deaths and tears of Ukrainian people.</p>
          <p class="marked_bold">It is no longer a question of business. It is a question of peace and life. </p>
        </div>
      </div>
    </section>
    <section class="brands-section">
      <div class="brands-section__wrapper">
        <div class="brands-section__sidebar">
          <div class="brands-section__sidebar__title">Categories</div>
          <div class="brands-section__categories">
            <div class="brands-section__categories__item" v-for="category in categories" :key="category.id" :class="{'brands-section__categories__item_selected': selectedCategory == category}" >
              <div class="brands-section__categories__item__title" @click="selectNewCategory(category)">
                {{category}}
              </div>
            </div>
          </div>
        </div>
        <div class="brands-section__cards" >
          <div class="loader" :class="{'loader_open' : loading}">
            <div class="loader-spin"></div>
          </div>
          <div class="search-wrapper">
            <img class="search-icon" src="@/assets/images/search.svg" />
            <input class="search-input" type="search" v-model="searchedBrand" placeholder="Search" role="searchbox" />
          </div>
          <div
            class="brands-section__cards__wrapper">
            <div class="brands-section__cards__item" v-for="(brand, i) in searchedList" :key="i">
              <a class="brands-section__cards__item__link" :class="{'events-none' : brand.article == ''}" target="_blank" :href="brand.article != '' ? brand.article : '/'">
                <div class="brands-section__cards__item__logo">
                  <img v-lazy="brand.logo" alt="ban-russia-brand" />
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
    <footer class="footer">
      <div class="contacts_wrapper">
        <div class="contacts">
          <a target="_blank" href="http://t.me/lkravchenko">
            Contact lkravchenko
            <img src="@/assets/images/telegram-icon.svg" />
          </a>
          </div>
      </div>
    </footer>
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
      loading: false,
      selectedCategory: 'all',
      searchedBrand: null,
      allPostsLoaded: false,
      lastId: 0,
      limit: 20,
      itemsLength: 20
    }
  },
  methods: {
    async fetchCountAndCategories () {
      await axios.get('https://api.byebye-russia.com/count')
        .then((response) => {
          this.count = response.data.count
          const fetchedCategories = response.data.categories.map(category => {
            if (category === 'clothes') {
              category = 'clothes & accessories'
            }
            return category
          })
          this.categories = fetchedCategories
        })
        .catch((error) => {
          console.log(error)
        })
      this.fetchItemsInCategory(this.categories[0])
    },

    checkWindowBtm () {
      window.onscroll = () => {
        const bottomOfWindow = document.documentElement.scrollTop + window.innerHeight === document.documentElement.offsetHeight
        if (bottomOfWindow && !this.allPostsLoaded) {
          this.fetchItemsInCategory(this.selectedCategory)
        }
      }
    },

    selectNewCategory (category) {
      this.items = []
      this.lastId = 0
      this.allPostsLoaded = false
      const brandsSection = document.querySelector('.brands-section')
      const top = brandsSection.offsetTop
      window.scrollTo(0, top)
      this.fetchItemsInCategory(category)
    },
    
    fetchItemsInCategory (category) {
      this.selectedCategory = category
      this.loading = true
      if (category === 'clothes & accessories') {
        category = 'clothes'
      }
      axios.get('https://api.byebye-russia.com/companies/' + category + '?last_id=' + this.lastId + '&limit=' + this.limit)
        .then((response) => {
          this.items = [...this.items, ...response.data]
          this.itemsLength = response.data.length
          this.lastId = this.items.pop().id
          this.loading = false
          this.checkTotalItems()
        })
        .catch((error) => {
          this.loading = false
          console.log(error)
        })
    },
    checkTotalItems () {
      if (this.itemsLength < this.limit) {
        this.allPostsLoaded = true
      }
    },
    fixSidebar () {
      const sidebar = document.querySelector('.brands-section__sidebar')
      const brandsSection = document.querySelector('.brands-section')
      const brandsSectionOffset = brandsSection.getBoundingClientRect().top
      if (brandsSectionOffset <= 0) {
        sidebar.classList.add('fixed')
      } else {
        sidebar.classList.remove('fixed')
      }
    }
  },
  watch: {
    loading () {
      document.body.style.overflow = this.loading ? 'hidden' : 'auto'
    }
  },
  mounted () {
    this.fetchCountAndCategories()
    this.checkWindowBtm()
  },
  computed: {
    dayDate: () => {
      return new Date().toLocaleDateString()
    },
    searchedList () {
      if (this.searchedBrand) {
        return this.items.filter(item => {
          return item.name.toLowerCase().includes(this.searchedBrand.toLowerCase())
        })
      } else {
        return this.items
      }
    },
    loadingDisabled () {
      return this.allPostsLoaded
    }
  },
  beforeMount () {
    window.addEventListener('scroll', this.fixSidebar)
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
