require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  # test data
  let!(:products) { create_list(:product, 10) }
  let(:product_id) { products.first.id }

  # Test GET /products
  describe 'GET /products' do
    before { get '/products' }

    it 'returns products' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test GET /products/:id
  describe 'GET /products/:id' do
    before { get "/products/#{product_id}" }

    context 'when the record exists' do
      it 'returns the product' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(product_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:product_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find Product with 'id'=100\"}")
      end
    end
  end

  # POST /products
  describe 'POST /products' do
    # valid payload
    let(:valid_attributes) { { name: 'Pollaso', description: Faker::Lorem.sentence, price: 10, stock: 5 } }

    context 'when the request is valid' do
      before { post '/products', params: valid_attributes }

      it 'creates a product' do
        expect(json['name']).to eq('Pollaso')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/products', params: { name: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"message\":\"Validation failed: Description can't be blank, Price can't be blank, Price is not a number, Stock can't be blank, Stock is not a number\"}")
      end
    end
  end

  # PUT /products/:id
  describe 'PUT /products/:id' do
    let(:product) { { name: 'Shopping', description: Faker::Lorem.sentence, price: 6, stock: 5 } }


    context 'when the record exists' do
      before { put "/products/#{2}", params: product }
      it 'updates the record' do
        expect(response.body).to be_empty
      end
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
    let(:product) { { id: product_id, name: 'Shopping', description: Faker::Lorem.sentence, price: -5, stock: -5 } }
    before { put "/products/#{product_id}", params: product }
    context 'when the price or stock are negative' do
      it 'the price is negative' do
        expect(response).to have_http_status(422)
      end
    end
  end

  # DELETE /products/:id
  describe 'DELETE /products/:id' do
    before { delete "/products/#{product_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
