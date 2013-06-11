class IHealth::API < Grape::API
  resource :data do
    get :hello do
        {:hello => "world"}
    end
    
    #url /data/temperature
    post :temperature do
      @tps = params[:temperature] 
      #@tmp = JSON.parse(tps)      
      #@tmp.each{ |tp| puts tp["email"]}
      PrivatePub.publish_to("/messages/new", :message => @tps)
      puts @tps
      @tps     
    end
    
    #url /data/ecg
    post :ecg do
      @tps = params[:ecg] 
      PrivatePub.publish_to("/messages/ecg", :message => @tps)
      puts @tps
      @tps     
    end
    
    #url /data/pulse_spo2
    post :ecg do
      @pulse = params[:pulse]
      @spo2 = params[:spo2] 
      PrivatePub.publish_to("/pulse_spo2", :pulse => @pulse, :spo2 => @spo2)
      r = "pulse = #{@pulse}  spo2 = #{@spo2}"
      puts r
      r
    end
  end
end