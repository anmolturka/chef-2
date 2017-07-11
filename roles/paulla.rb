# coding: utf-8

name "paulla"
description "Role applied to all servers at PauLLA"

default_attributes(
  :accounts => {
    :users => {
      :redfox => { :status => :administrator },
      :jpcw => { :status => :administrator }
    }
  },
  :hosted_by => "Université de Pau et des Pays de l'Adour",
  :location => "Pau, France",
  :munin => {
    :allow => ["10.64.1.11"]
  },
  :networking => {
    :nameservers => ["10.64.1.42", "194.167.156.13", "10.64.1.3"],
    :roles => {
      :external => {
        :zone => "pa"
      }
    }
  }
)

override_attributes(
  :ntp => {
    :servers => ["cannelle.paulla.asso.fr"]
  }
)

run_list(
  "role[fr]"
)
