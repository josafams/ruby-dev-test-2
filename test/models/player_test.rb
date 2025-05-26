require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test 'valid player' do
    player = Player.new(name: 'Madonna')
    assert player.valid?
  end

  test 'presence of name' do
    player = Player.new
    assert_not player.valid?
    assert_not_empty player.errors[:name]
  end

  test 'player can have many albums through album_players' do
    player = players(:shakira)

    new_album = Album.new(name: 'New Album')
    new_album.players << player
    new_album.save!

    assert_includes player.albums, albums(:fijacion)
    assert_includes player.albums, new_album
    assert player.albums.count >= 2
  end

  test 'destroying player destroys album_players' do
    player = players(:shakira)
    initial_count = AlbumPlayer.count
    player_album_players_count = player.album_players.count

    player.destroy

    assert_equal initial_count - player_album_players_count, AlbumPlayer.count
  end

  test 'player can collaborate on same album with other players' do
    album = albums(:fijacion)
    madonna = Player.create!(name: 'Madonna')

    album.players << madonna

    assert_includes album.players, players(:shakira)
    assert_includes album.players, madonna
    assert_equal 2, album.players.count
  end
end
