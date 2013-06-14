class IHealth::API < Grape::API
  resource :data do
    get :hello do
        {:hello => "world"}
    end
    
    #url /data/temperature
    post :temperature do
      tps = params[:temperature] 
      #@tmp = JSON.parse(tps)      
      #@tmp.each{ |tp| puts tp["email"]}
      PrivatePub.publish_to("/temperature", :message => tps)
      puts tps
      tps     
    end
    
    #url /data/ecg
    post :ecg do
      tps = params[:ecg] 
      PrivatePub.publish_to("/ecg", :message => tps)
      puts tps
      @tps     
    end
    
    #url /data/ecgs("ecgs":{"ecg":1,"ecg":2...})
    post :ecgs do
      ecgs = params[:ecgs] 
      ecgJson = JSON.parse(ecgs)      
      ecgJson.each do |ecg|
          puts ecg["ecg"]
      end
         
      PrivatePub.publish_to("/ecgs", :message => ecgJson)
      puts ecgs
      ecgs     
    end
    
    #url /data/pulse_spo2
    post :pulse_spo2 do
      pulse = params[:pulse]
      spo2 = params[:spo2] 
      PrivatePub.publish_to("/pulse_spo2", :pulse => pulse, :spo2 => spo2)
      r = "pulse = #{pulse}  spo2 = #{spo2}"
      puts r
      r
    end
    
    #url /data/breath
    post :breath do
      breath = params[:breath]
      PrivatePub.publish_to("/breath", :breath => breath)
      r = "breath = #{breath}"
      puts r
      r
    end
    
    #url /data/breaths("breaths":{"breath":1,"breath":2...})
    post :breaths do
      breaths = params[:breaths] 
      breathJson = JSON.parse(breaths)      
      breathJson.each do |breath|
          puts breath["breath"]
      end         
      PrivatePub.publish_to("/breaths", :breaths => breathJson)
      puts breaths
      breaths     
    end
  end
end