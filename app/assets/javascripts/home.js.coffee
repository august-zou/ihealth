# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
dataT =  [0,0,0,0,0]
  
PrivatePub.subscribe "/messages/new", (data, channel) ->
  $(".temperature").append("<li>"+data.message+"</li>")
  $("#charts").empty()
  dataT.shift()
  dataT.push(data.message)
  dataTemperature =  [
        { step: '1', value: dataT[0] },
        { step: '2', value: dataT[1] },
        { step: '3', value: dataT[2] },
        { step: '4', value: dataT[3] },
        { step: '5', value: dataT[4] }
        ]
        
  new Morris.Line({   
    element: 'charts',
    data: dataTemperature ,
    xkey: 'step',
    ykeys: ['value'],
    parseTime: false,
    smooth: false,
    labels: ['value']
    })