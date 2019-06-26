# frozen_string_literal: true

RSpec.describe ActiveRecordInCache do
  around { |example| freeze_time(&example) }
  after do
    Article.delete_all
    Comment.delete_all
    Rails.cache.clear
  end

  it 'returns records and save into cache' do
    article = Article.create

    rel = Article.all
    expect(rel.in_cache).to contain_exactly(article)
    expect(Rails.cache).to be_exist "#{rel.to_sql}_#{article.updated_at}"
  end

  it 'does not use cache after updating a new record' do
    article_1 = Article.create

    rel = Article.all
    expect(rel.in_cache).to contain_exactly(article_1)

    article_2 = Article.create(updated_at: 1.minute.from_now)
    expect(rel.in_cache).to contain_exactly(article_1, article_2)
  end

  it 'returns records using the specified column' do
    article = Article.create(published_at: 1.minute.ago)
    Article.create(published_at: nil)

    rel = Article.published
    expect(rel.in_cache(:published_at)).to contain_exactly(article)
    expect(Rails.cache).to be_exist "#{rel.to_sql}_#{article.published_at}"
  end

  it 'returns records in SQL using joins' do
    article = Article.create
    comment = Comment.create(article: article)

    rel = Comment.joins(:article)
    expect(rel.in_cache).to contain_exactly(comment)
    expect(Rails.cache).to be_exist "#{rel.to_sql}_#{comment.updated_at}"
  end

  it 'returns an empty array' do
    rel = Article.all
    expect(rel.in_cache).to eq []
    expect(Rails.cache).to be_exist "#{rel.to_sql}_"
  end

  it 'returns records using the custom key' do
    article = Article.create

    rel = Article.all
    records = rel.in_cache { "#{maximum(:updated_at)}_v2" }
    expect(records).to contain_exactly(article)
    expect(Rails.cache).to be_exist "#{rel.to_sql}_#{article.updated_at}_v2"
  end
end
