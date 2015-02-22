require "test_helper"

module PushType
  describe FieldType do

    let(:field) { PushType::FieldType.new :foo, opts }
    let(:val)   { '1' }
    
    describe 'default' do
      let(:opts) { {} }
      it { field.name.must_equal 'foo' }
      it { field.param.must_equal :foo }
      it { field.kind.must_equal 'field' }
      it { field.template.must_equal 'default' }
      it { field.label.must_equal 'Foo' }
      it { field.html_options.must_equal({}) }
      it { field.form_helper.must_equal :text_field }
      it { field.column_class.must_equal nil }
      it { field.to_json(val).must_equal '1' }
      it { field.from_json(val).must_equal '1' }
    end

    describe 'with options' do
      let(:opts)  { { template: 'my_template', label: 'Bar', html_options: { some: 'opts' }, form_helper: :number_field, colspan: 2 } }
      it { field.name.must_equal 'foo' }
      it { field.kind.must_equal 'field' }
      it { field.template.must_equal opts[:template] }
      it { field.label.must_equal opts[:label] }
      it { field.html_options.must_equal opts[:html_options] }
      it { field.form_helper.must_equal opts[:form_helper] }
      it { field.column_class.must_equal 'medium-6' }
      it { field.to_json(val).must_equal '1' }
      it { field.from_json(val).must_equal '1' }
    end

    describe DateField do
      let(:field) { PushType::DateField.new :foo }
      let(:val)   { Date.today.to_s }
      it { field.form_helper.must_equal :date_field }
      it { field.from_json(val).must_be_instance_of Date }
    end

    describe NumberField do
      let(:field) { PushType::NumberField.new :foo }
      it { field.form_helper.must_equal :number_field }
      it { field.from_json(val).must_equal 1 }
      it { field.to_json(val).must_equal 1 }
    end

    describe TextField do
      let(:field) { PushType::TextField.new :foo }
      it { field.form_helper.must_equal :text_area }
    end

    describe ArrayField do
      let(:field) { PushType::ArrayField.new :foo }
      it { field.param.must_equal foo: [] }
      it { field.to_json(val).must_equal ['1'] }
      it { field.from_json(val).must_equal ['1'] }
    end

    describe TagListField do
      let(:field) { PushType::TagListField.new :foo }
      it { field.template.must_equal 'tag_list' }
      it { field.html_options[:multiple].must_equal true }
      it { field.html_options[:placeholder].must_equal 'Tags...' }
      it { field.html_options[:class].must_equal 'tagsinput' }

      describe 'dynamic methods' do
        before do
          DatabaseCleaner.clean_with :truncation
          Page.fields = ActiveSupport::OrderedHash.new
          Page.field :tags, :tag_list
          Page.create FactoryGirl.attributes_for(:node, tags: ['foo', 'bar'])
        end
        after { Page.fields = ActiveSupport::OrderedHash.new }
        it { Page.all_tags.must_equal ['bar', 'foo'] }
      end
    end

  end
end
