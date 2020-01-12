# frozen_string_literal: true

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
    # invalid payload
    let(:invalid_attributes) { { name: 'Pollaso', description: Faker::Lorem.sentence, price: -5, stock: 5 } }

    context 'when the request is valid' do
      before { post '/products', params: valid_attributes }

      it 'creates a product' do
        expect(json['name']).to eq('Pollaso')
        expect(json['id']).to_not be_nil
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid, negative price' do
      before { post '/products', params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match('{"message":"Validation failed: Price must be greater than or equal to 0"}')
      end
    end
  end

  # PUT /products/:id
  describe 'PUT /products/:id' do
    let(:valid_attributes) { { name: 'Shopping', description: Faker::Lorem.sentence, price: 6, stock: 5 } }
    let(:invalid_attributes) { { name: nil, description: nil, price: 6, stock: 5 } }
    let(:invalid_price) { { name: 'Shopping', description: Faker::Lorem.sentence, price: -5, stock: -5 } }

    context 'when the record exists' do
      it 'updates the record' do
        put "/products/#{product_id}", params: valid_attributes
        expect(json).to_not be_nil
        expect(json['id']).to eq(product_id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the price or stock are negative' do
      it 'the price is negative' do
        put "/products/#{product_id}", params: invalid_price
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
