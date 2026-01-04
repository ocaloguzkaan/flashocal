# FlashOcal Framework

**FlashOcal** is a structured, robust, and efficient **ActionScript 2.0** game development framework designed for Flash 8 and cleaner legacy projects. It brings modern game development patterns (Component-based architecture, Object Pooling, State Management) to the AS2 environment.

It separates logic from the view (MovieClips), promotes strict typing, and includes a comprehensive suite of managers to handle common game dev tasks like Physics, Localization, and Transitions.

---

## 🚀 Features

*   **Core Engine**: Robust game loop with fixed timestep support and "Headless" mode for testing.
*   **State Management**: `GameStateManager` for handling game states (Menu, Playing, Paused, GameOver).
*   **Physics Engine**: Built-in 2D `PhysicsWorld` with RigidBody dynamics, collision resolution, and static/dynamic object support.
*   **Managers**:
    *   **Input**: Centralized keyboard handling with helper methods (`isDown`, key constants).
    *   **Sound**: Global sound management, volume control, and automatic cleanup.
    *   **Screen**: Easy screen navigation and management (`IScreen` interface).
    *   **Localization**: Multi-language support (JSON-based) with automatic font mapping for special characters (supports EN (English), TR (Turkish), ES (Spanish), RU (Russian), JA (Japanese), ZH (Chinese), etc.).
    *   **Transition**: Integrated overlay transitions (Fade in/out) between screens.
    *   **Save**: `SaveManager` wrapper for `SharedObject` to easily persist data.
    *   **Asset Loader**: Queue-based loader for external SWFs and images.
*   **Performance**:
    *   **Object Pooling**: `DecorationManager` demonstrates pooling for high-performance spawning.
    *   **Prefab Factory**: Data-driven object creation (JSON definitions to MovieClips).
    *   **Direct Drawing**: Fallbacks for procedural generation using drawing APIs.
*   **Debugging**:
    *   **In-Game Console**: Press `~` (or configured key) to open a runtime debug console.
    *   **Logger**: Standardized logging utility `Logger.log()`.

---

## 📦 Installation

1.  **Download**: Clone or download this repository.
2.  **Setup**: Copy the `tr` folder (located inside `src`) into the same directory as your `.fla` file.
3.  **Import**: You can now import classes using `import tr.flashocal.*;`.

---

## 🛠 Usage

### 1. Initialize the Engine
In the first frame of your main FLA file:

```actionscript
import tr.flashocal.core.Engine;
import tr.flashocal.managers.ScreenManager;

// Initialize Engine on the root timeline (non-headless)
Engine.init(_root, false);

// Example: Switch to your initial screen
// ScreenManager.getInstance().changeScreen(new MyGameScreen(_root.createEmptyMovieClip("game_screen", 1)));
```

### 2. Creating a Game Object
Extend `GameObject` to separate your logic from the visual `MovieClip`.

```actionscript
import tr.flashocal.objects.GameObject;

class Player extends GameObject {
    
    public function Player(targetMC:MovieClip) {
        super(targetMC);
        this.velocityX = 5;
    }
    
    public function update(dt:Number):Void {
        super.update(dt); // Handles x += velocityX * dt
        
        // Add custom logic
        if (this.x > 500) {
            this.active = false; // Will be safely removed
        }
    }
}
```

### 3. Using Physics
```actionscript
import tr.flashocal.physics.PhysicsWorld;
import tr.flashocal.physics.RigidBody;

var world:PhysicsWorld = new PhysicsWorld();
world.gravity_Y = 0.5;

var box:RigidBody = new RigidBody(myMovieClip);
box.mass = 1.0;
box.restitution = 0.7; // Bouncy

world.addBody(box);

// In your update loop:
world.update();
```

---

## 📂 Directory Structure

*   **`tr.flashocal.core`**: `Engine`, `GameStateManager`, `ServiceLocator`, `PrefabFactory`
*   **`tr.flashocal.managers`**: `Input`, `Sound`, `Screen`, `Transition`, `Localization`, `AssetLoader`
*   **`tr.flashocal.objects`**: Base classes (`GameObject`, `BaseScreen`)
*   **`tr.flashocal.physics`**: `PhysicsWorld`, `RigidBody`
*   **`tr.flashocal.utils`**: `Logger`, `MathUtils`
*   **`tr.flashocal.debug`**: `Console`
*   **`tr.flashocal.events`**: Custom event system implementation.

---

## 📄 License
This project is open-source and free to use for any personal or commercial project.

Built with ❤️ for the Flash preservation community.
