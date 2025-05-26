require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'valid album with one player' do
    album = Album.new(name: 'Peligro')
    album.players << players(:shakira)
    assert album.valid?
  end

  test 'valid album with multiple players' do
    album = Album.new(name: 'Collaboration')
    album.players << players(:shakira)
    album.players << players(:beyonce)
    assert album.valid?
  end

  test 'presence of name' do
    album = Album.new
    assert_not album.valid?
    assert_not_empty album.errors[:name]
  end

  test 'presence of players' do
    album = Album.new(name: 'Test Album')
    assert_not album.valid?
    assert_not_empty album.errors[:players]
  end

  test 'album can have many players through album_players' do
    album = albums(:fijacion)
    album.players << players(:beyonce)

    assert_equal 2, album.players.count
    assert_includes album.players, players(:shakira)
    assert_includes album.players, players(:beyonce)
  end

  test 'destroying album destroys album_players' do
    album = albums(:fijacion)
    album_player_count = AlbumPlayer.count

    album.destroy

    assert_equal album_player_count - 1, AlbumPlayer.count
  end
end
