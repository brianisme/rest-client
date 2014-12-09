require 'spec_helper'

module RestClient
  describe MaxQueue do
    let(:subject) { MaxQueue.new max }
    let(:max) { 5 }

    def add_items(num)
      num.times do |i|
        subject << i
      end
    end

    context 'when adding an item' do
      let(:new_item) { 10 }
      let(:size) { 1 }

      before do
        add_items size
        subject.push new_item
      end

      context 'when queue is full' do
        let(:size) { max }

        it 'removes the first item' do
          expect(subject.first).to be 1
        end
      end

      context 'when queue is not full' do

        it 'increases the size' do
          expect(subject.size).to be size+1
        end

        it 'keeps the first item intact' do
          expect(subject.first).to be 0
        end
      end

      it 'adds the new item to the last' do
        expect(subject.last).to be new_item
      end
    end

    context 'when assign item using brackets' do
      let(:idx) { 0 }
      def assignment
        subject[idx] = 123
      end

      context 'when out of bound' do
        let(:idx) { max }
        it 'raise an index error' do
          expect { assignment }.to raise_error(IndexError)
        end
      end

      context 'when inside of bound' do
        it 'assigns the value' do
          assignment
          expect(subject[idx]).to be 123
        end
      end
    end
  end
end
