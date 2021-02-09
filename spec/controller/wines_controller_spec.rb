require 'rails_helper'
RSpec.describe WinesController, type: :controller do
    describe "GET index" do
        it "assigns @wines" do
            wine = Wine.create(name: "Buen Vino")
            get :index
            expect(assigns(:wine))==([wine])
        end
        it "renders the index template" do
            get :index
            expect(response).to have_http_status(302)
        end
        it "renders the show template" do
            get(:show, params:{id: 5})
            expect(response).to have_http_status(302)
        end
    end

    
end