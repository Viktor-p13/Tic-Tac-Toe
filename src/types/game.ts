export type Player = 'X' | 'O'

export type CellValue = Player | null

export type BoardState = CellValue[]

export type GameStatus = 'playing' | 'won' | 'draw'

export interface GameState {
  board: BoardState
  currentPlayer: Player
  status: GameStatus
  winner: Player | null
}
