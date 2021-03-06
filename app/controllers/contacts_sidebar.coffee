Spine   = require('spine')
Contact = require('models/contact')
List = require('spine/lib/list')
$       = Spine.$

class Sidebar extends Spine.Controller
  className: 'sidebar'

  elements:
    '.items': 'items'
    'input': 'search'

  events:
    'keyup input': 'filter'
    'click .item': 'clicked'
    'click footer button': 'create'

  constructor: ->
    super
    # Render initial view
    @html require('views/sidebar')()

    # Setup a Spine List
    @list = new Spine.List
      el: @items, 
      template: require('views/item'), 
      selectFirst: true

    @list.bind 'change', @change
    
    Contact.fetch()
    Contact.bind('refresh', @saveToLocal)

    @active (params) -> 
      @list.change(Contact.find(params.id))
      $(".items .item").removeClass("selected")
      $("#" + params.id).addClass("selected")

    Contact.bind('refresh change', @render)

  filter: ->
    @query = @search.val()
    @render()

  render: =>
    contacts = Contact.filter(@query)
    @list.render(contacts)

  clicked: (e) ->
    $(e.target).addClass("selected")

  change: (item) =>
    @navigate '/contacts', item.id

  create: ->
    item = Contact.create()
    @navigate('/contacts/new')

  saveToLocal: ->
    Contact.saveLocal()

module.exports = Sidebar