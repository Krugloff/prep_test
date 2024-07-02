import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    limit: Number
  }

  check(event) {
    if (event.target.checked) {
      let counterValue = this.element.querySelectorAll('input:checked').length

      if (counterValue > this.limitValue) { 
        event.target.checked = false
        event.preventDefault()
      }
    }
  }
}