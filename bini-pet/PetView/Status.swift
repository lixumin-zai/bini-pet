


import SwiftUI

//struct PetColor: Hashable {
//    // Define properties for PetColor
//}
//
//struct PetType: Hashable {
//    // Define properties for PetType
//}
//
//protocol IPetType {
//    func nextFrame()
//    
//    // Special methods for actions
//    var canSwipe: Bool { get }
//    var canChase: Bool { get }
//    func swipe()
//    var speed: Double { get }
//    var isMoving: Bool { get }
//    var hello: String { get }
//    
//    // State API
//    func getState() -> PetInstanceState
//    func recoverState(state: PetInstanceState)
//    func recoverFriend(friend: IPetType)
//    
//    // Positioning
//    var bottom: Double { get set }
//    var left: Double { get set }
//    func positionBottom(bottom: Double)
//    func positionLeft(left: Double)
//    var width: Double { get }
//    var floor: Double { get }
//}
//
//class PetInstanceState {
//    var currentStateEnum: States?
//}
//
//class PetElementState {
//    var petState: PetInstanceState?
//    var petType: PetType?
//    var petColor: PetColor?
//    var elLeft: String?
//    var elBottom: String?
//    var petName: String?
//    var petFriend: String?
//}
//
//class PetPanelState {
//    var petStates: [PetElementState]?
//    var petCounter: Int?
//}
//
//enum HorizontalDirection {
//    case left
//    case right
//    case natural // No change to current direction
//}
//
//enum States: String {
//    case sitIdle = "sit-idle"
//    case walkRight = "walk-right"
//    case walkLeft = "walk-left"
//    case runRight = "run-right"
//    case runLeft = "run-left"
//    case lie = "lie"
//    case wallHangLeft = "wall-hang-left"
//    case climbWallLeft = "climb-wall-left"
//    case jumpDownLeft = "jump-down-left"
//    case land = "land"
//    case swipe = "swipe"
//    case idleWithBall = "idle-with-ball"
//    case chase = "chase"
//    case chaseFriend = "chase-friend"
//    case standRight = "stand-right"
//    case standLeft = "stand-left"
//}
//
//enum FrameResult {
//    case stateContinue
//    case stateComplete
//    case stateCancel
//}
//
//class BallState {
//    var cx: Double
//    var cy: Double
//    var vx: Double
//    var vy: Double
//    var paused: Bool
//    
//    init(cx: Double, cy: Double, vx: Double, vy: Double) {
//        self.cx = cx
//        self.cy = cy
//        self.vx = vx
//        self.vy = vy
//        self.paused = false
//    }
//}
//
//func isStateAboveGround(state: States) -> Bool {
//    return state == .climbWallLeft || state == .jumpDownLeft || state == .land || state == .wallHangLeft
//}
//
//func resolveState(state: String, pet: IPetType) -> IState {
//    switch state {
//    case States.sitIdle.rawValue:
//        return SitIdleState(pet: pet)
//    case States.walkRight.rawValue:
//        return WalkRightState(pet: pet)
//    case States.walkLeft.rawValue:
//        return WalkLeftState(pet: pet)
//    case States.runRight.rawValue:
//        return RunRightState(pet: pet)
//    case States.runLeft.rawValue:
//        return RunLeftState(pet: pet)
//    case States.lie.rawValue:
//        return LieState(pet: pet)
//    case States.wallHangLeft.rawValue:
//        return WallHangLeftState(pet: pet)
//    case States.climbWallLeft.rawValue:
//        return ClimbWallLeftState(pet: pet)
//    case States.jumpDownLeft.rawValue:
//        return JumpDownLeftState(pet: pet)
//    case States.land.rawValue:
//        return LandState(pet: pet)
//    case States.swipe.rawValue:
//        return SwipeState(pet: pet)
//    case States.idleWithBall.rawValue:
//        return IdleWithBallState(pet: pet)
//    case States.chaseFriend.rawValue:
//        return ChaseFriendState(pet: pet)
//    case States.standRight.rawValue:
//        return StandRightState(pet: pet)
//    case States.standLeft.rawValue:
//        return StandLeftState(pet: pet)
//    default:
//        return SitIdleState(pet: pet)
//    }
//}
//
//protocol IState {
//    var label: String { get }
//    var spriteLabel: String { get }
//    var horizontalDirection: HorizontalDirection { get }
//    var pet: IPetType { get }
//    func nextFrame() -> FrameResult
//}
//
//class AbstractStaticState: IState {
//    var label = States.sitIdle.rawValue
//    var idleCounter: Int = 0
//    var spriteLabel = "idle"
//    var holdTime = 50
//    var pet: IPetType
//    
//    var horizontalDirection = HorizontalDirection.left
//    
//    init(pet: IPetType) {
//        self.pet = pet
//    }
//    
//    func nextFrame() -> FrameResult {
//        idleCounter += 1
//        if idleCounter > holdTime {
//            return .stateComplete
//        }
//        return .stateContinue
//    }
//}
//
//class SitIdleState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.sitIdle.rawValue
//        spriteLabel = "idle"
//        horizontalDirection = .right
//        holdTime = 50
//    }
//}
//
//class LieState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.lie.rawValue
//        spriteLabel = "lie"
//        horizontalDirection = .right
//        holdTime = 50
//    }
//}
//
//class WallHangLeftState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.wallHangLeft.rawValue
//        spriteLabel = "wallgrab"
//        horizontalDirection = .left
//        holdTime = 50
//    }
//}
//
//class LandState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.land.rawValue
//        spriteLabel = "land"
//        horizontalDirection = .left
//        holdTime = 10
//    }
//}
//
//class SwipeState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.swipe.rawValue
//        spriteLabel = "swipe"
//        horizontalDirection = .natural
//        holdTime = 15
//    }
//}
//
//class IdleWithBallState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.idleWithBall.rawValue
//        spriteLabel = "with_ball"
//        horizontalDirection = .left
//        holdTime = 30
//    }
//}
//
//class WalkRightState: IState {
//    var label = States.walkRight.rawValue
//    var pet: IPetType
//    var spriteLabel = "walk"
//    var horizontalDirection = HorizontalDirection.right
//    var leftBoundary: Double
//    var speedMultiplier = 1.0
//    var idleCounter: Int = 0
//    var holdTime = 60
//    
//    init(pet: IPetType) {
//        self.leftBoundary = floor(Double(UIScreen.main.bounds.width) * 0.95)
//        self.pet = pet
//    }
//    
//    func nextFrame() -> FrameResult {
//        idleCounter += 1
//        pet.positionLeft(left: pet.left + pet.speed * speedMultiplier)
//        if pet.isMoving && pet.left >= leftBoundary - pet.width {
//            return .stateComplete
//        } else if !pet.isMoving && idleCounter > holdTime {
//            return .stateComplete
//        }
//        return .stateContinue
//    }
//}
//
//class WalkLeftState: IState {
//    var label = States.walkLeft.rawValue
//    var spriteLabel = "walk"
//    var horizontalDirection = HorizontalDirection.left
//    var pet: IPetType
//    var speedMultiplier = 1.0
//    var idleCounter: Int = 0
//    var holdTime = 60
//    
//    init(pet: IPetType) {
//        self.pet = pet
//    }
//    
//    func nextFrame() -> FrameResult {
//        pet.positionLeft(left: pet.left - pet.speed * speedMultiplier)
//        if pet.isMoving && pet.left <= 0 {
//            return .stateComplete
//        } else if !pet.isMoving && idleCounter > holdTime {
//            return .stateComplete
//        }
//        return .stateContinue
//    }
//}
//
//class RunRightState: WalkRightState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.runRight.rawValue
//        spriteLabel = "walk_fast"
//        speedMultiplier = 1.6
//        holdTime = 130
//    }
//}
//
//class RunLeftState: WalkLeftState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.runLeft.rawValue
//        spriteLabel = "walk_fast"
//        speedMultiplier = 1.6
//        holdTime = 130
//    }
//}
//
//class ChaseState: IState {
//    var label = States.chase.rawValue
//    var spriteLabel = "run"
//    var horizontalDirection = HorizontalDirection.left
//    var ballState: BallState
//    var canvas: Canvas
//    var pet: IPetType
//    
//    init(pet: IPetType, ballState: BallState, canvas: Canvas) {
//        self.pet = pet
//        self.ballState = ballState
//        self.canvas = canvas
//    }
//    
//    func nextFrame() -> FrameResult {
//        if ballState.paused {
//            return .stateCancel
//        }
//        if pet.left > ballState.cx {
//            horizontalDirection = .left
//            pet.positionLeft(left: pet.left - pet.speed)
//        } else {
//            horizontalDirection = .right
//            pet.positionLeft(left: pet.left + pet.speed)
//        }
//        
//        if canvas.height - ballState.cy < pet.width + pet.floor && ballState.cx < pet.left && pet.left < ballState.cx + 15 {
//            canvas.isHidden = true
//            ballState.paused = true
//            return .stateComplete
//        }
//        return .stateContinue
//    }
//}
//
//class ChaseFriendState: IState {
//    var label = States.chaseFriend.rawValue
//    var spriteLabel = "run"
//    var horizontalDirection = HorizontalDirection.left
//    var pet: IPetType
//    
//    init(pet: IPetType) {
//        self.pet = pet
//    }
//    
//    func nextFrame() -> FrameResult {
//        guard pet.hasFriend, pet.friend?.isPlaying == true else {
//            return .stateCancel
//        }
//        if pet.left > pet.friend!.left {
//            horizontalDirection = .left
//            pet.positionLeft(left: pet.left - pet.speed)
//        } else {
//            horizontalDirection = .right
//            pet.positionLeft(left: pet.left + pet.speed)
//        }
//        return .stateContinue
//    }
//}
//
//class ClimbWallLeftState: IState {
//    var label = States.climbWallLeft.rawValue
//    var spriteLabel = "wallclimb"
//    var horizontalDirection = HorizontalDirection.left
//    var pet: IPetType
//    
//    init(pet: IPetType) {
//        self.pet = pet
//    }
//    
//    func nextFrame() -> FrameResult {
//        pet.positionBottom(bottom: pet.bottom + 1)
//        if pet.bottom >= 100 {
//            return .stateComplete
//        }
//        return .stateContinue
//    }
//}
//
//class JumpDownLeftState: IState {
//    var label = States.jumpDownLeft.rawValue
//    var spriteLabel = "fall_from_grab"
//    var horizontalDirection = HorizontalDirection.right
//    var pet: IPetType
//    
//    init(pet: IPetType) {
//        self.pet = pet
//    }
//    
//    func nextFrame() -> FrameResult {
//        pet.positionBottom(bottom: pet.bottom - 5)
//        if pet.bottom <= pet.floor {
//            pet.positionBottom(bottom: pet.floor)
//            return .stateComplete
//        }
//        return .stateContinue
//    }
//}
//
//class StandRightState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.standRight.rawValue
//        spriteLabel = "stand"
//        horizontalDirection = .right
//        holdTime = 60
//    }
//}
//
//class StandLeftState: AbstractStaticState {
//    override init(pet: IPetType) {
//        super.init(pet: pet)
//        label = States.standLeft.rawValue
//        spriteLabel = "stand"
//        horizontalDirection = .left
//        holdTime = 60
//    }
//}
