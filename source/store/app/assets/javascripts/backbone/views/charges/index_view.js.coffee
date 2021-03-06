Store.Views.Charges ||= {}

class Store.Views.Charges.IndexView extends Backbone.View
  template: JST["backbone/templates/charges/index"]

  initialize: () ->
    @options.charges.bind('reset', @addAllLists)

  addAllLists: () =>
    @addFailedList()
    @addDisputedList()
    @addSuccessfulList()

  addFailedList: () =>
    failedCharges = @options.charges.where {paid: false}
    failedChargesCollection = new Store.Collections.ChargesCollection(failedCharges)
    failedChargesView = new Store.Views.Charges.FailedChargesView({charges: failedChargesCollection})
    $("body").append(failedChargesView.render().el)

  addDisputedList: () =>
    disputedCharges = @options.charges.where {refunded: true}
    disputedChargesCollection = new Store.Collections.ChargesCollection(disputedCharges)
    disputedChargesView = new Store.Views.Charges.DisputedChargesView({charges: disputedChargesCollection})
    $("body").append(disputedChargesView.render().el)

  addSuccessfulList: () =>
    successfulCharges = @options.charges.where {paid: true, refunded: false}
    successfulChargesCollection = new Store.Collections.ChargesCollection(successfulCharges)
    successfulChargesView = new Store.Views.Charges.SuccessfulChargesView({charges: successfulChargesCollection})
    $("body").append(successfulChargesView.render().el)

  # This is called by the router when the charges view is requested. It creates a view from the charges it's passed,
  # then puts the HTML from that view on the view's el property, ready to be put into the page.
  render: =>
    $(@el).html(@template(charges: @options.charges.toJSON() ))
    @addAllLists()

    return this
