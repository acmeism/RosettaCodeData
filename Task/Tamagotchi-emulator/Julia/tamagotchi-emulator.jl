using Gtk, GtkUtilities, Cairo, Images

mutable struct Pet
    species::String
    name::String
    age::Int  # days
    weight::Int
    health::Int
    hunger::Int
    happiness::Int
    Pet() = new("Dog", "Tam", 366, 3, 8, 4, 8)
end

introduce(pet) = "Hello! My name is $(pet.name) and I am your pet, a $(pet.age ÷ 365)-year-old $(pet.species)!"
wellbeing(pet) = "My weight is $(pet.weight), I have $(pet.health) health points and $(pet.happiness) happy points."
request(pet) = "Please look after me..."
increase_health(pet::Pet) = (pet.health += (pet.health < 8) ? 1 : 0)
decrease_health(pet::Pet) = (pet.health -= (pet.health > 2) ? 1 : 0)
increase_weight(pet) = (pet.weight += (pet.weight < 8) ? 1 : 0)
decrease_weight(pet) = (pet.weight < 3 ? decrease_health(pet) : pet.weight -= 1)
decrease_hunger(pet) = (pet.hunger -= (pet.hunger > 2) ? 1 : 0)
increase_hunger(pet) = (pet.hunger += (pet.hunger < 8) ? 1 : 0)
increase_happiness(pet) = (pet.happiness += (pet.happiness < 8) ? 1 : 0)
decrease_happiness(pet) = (pet.happiness < 3 ?  decrease_health(pet) : pet.happiness -= 1)

const pet_default_image = load("/users/wherr/documents/Julia Programs/pet_default.png")
const pet_cuddle_image = load("/users/wherr/documents/Julia Programs/pet_cuddle.png")
const pet_feeding_image = load("/users/wherr/documents/julia programs/pet_feeding.png")
const pet_catch_stick_image = load("/users/wherr/documents/julia programs/pet_catch_stick.png")
const pet_sleeping_image = load("/users/wherr/documents/julia programs/pet_sleeping.png")
const pet_tailchase_image = load("/users/wherr/documents/julia programs/pet_tailchase.png")
const pet_poop_image = load("/users/wherr/documents/julia programs/pet_poop.png")
const pet_walk_image = load("/users/wherr/documents/julia programs/pet_walk.png")
const pet_vet_image = load("/users/wherr/documents/julia programs/pet_vet.png")
const pet_sick_image = load("/users/wherr/documents/julia programs/pet_sick.png")
const pet_death_image = load("/users/wherr/documents/julia programs/pet_death.png")

function TamagotchiApp()
    poop_chance = 0.1
    old_age_end_chance = 0.2
    health_end_chance = 0.2
    waiting_time = 15
    pet = Pet()
    win = Gtk.Window(pet.name, 500, 700)
    button_yes = false
    button_no = false
    label = Gtk.Label(introduce(pet))
    canvas = Gtk.GtkCanvas()
    button1 = Gtk.Button("Yes")
    button2 = Gtk.Button("No")
    status = Gtk.Label(" ")
    vbox = Gtk.GtkBox(:v)
    bbox = Gtk.GtkBox(:h)
    push!(bbox, button1, button2, status)
    push!(vbox, label, canvas, bbox)
    push!(win, vbox)
    set_gtk_property!(vbox, :expand, true)
    set_gtk_property!(canvas, :expand, true)
    current_image = pet_default_image
    showall(win)
    info_dialog(introduce(pet))
    info_dialog(wellbeing(pet))

    @guarded draw(canvas) do widget
        ctx = getgc(canvas)
        copy!(ctx, current_image)
    end

    update_image(img) = (current_image = img; draw(canvas))

    function update_status()
        str = "    Age " * rpad(pet.age ÷ 365, 5) * "Weight " * rpad(pet.weight, 5) * "Hunger " *
            rpad(pet.hunger, 5) * "Happiness " * rpad(pet.happiness, 3)
        GAccessor.text(status, str)
    end

    function waitforbutton()
        button_yes, button_no = false, false
        t1 = time()
        while time() - t1 < waiting_time
            button_yes && return true
            button_no && return false
            sleep(0.2)
        end
        return false
    end

    function cuddles()
        clear_buttons()
        GAccessor.text(label, "Puppy is bored.\nDo you want to give Puppy a cuddle?")
        yesno = waitforbutton()
        if yesno
            increase_happiness(pet)
            if pet.happiness < 8
                GAccessor.text(label, "Yay! Happiness has increased to $(pet.happiness)!")
            elseif pet.happiness == 8
                GAccessor.text(label, "Yay! Happiness is at maximum of $(pet.happiness)!")
            end
            update_image(pet_cuddle_image)
        else
            decrease_happiness(pet)
            GAccessor.text(label, "Are you sure? Puppy really loves cuddles!\n" *
                "Happiness has decreased to $(pet.happiness)!")
        end
    end

    function hungry()
        GAccessor.text(label, "I'm hungry, feed me!")
        if waitforbutton()
            if pet.weight < 8
                increase_weight(pet)
                GAccessor.text(label, "Yay! nomnomnom\nWeight has increased to $(pet.weight)!")
            elseif pet.weight == 8
                GAccessor.text(label, "Yay! nomnomnom\nWeight is $(pet.weight)!")
            end
            decrease_hunger(pet)
            decrease_hunger(pet)
            poop_chance += 0.1
            update_image(pet_feeding_image)
        else
            decrease_weight(pet)
            GAccessor.text(label, "Aww, a hungry pet...\nWeight has decreased to $(pet.weight).")
        end
    end

    function play_stick()
        GAccessor.text(label, "Puppy is bored.\nWould you like to play a game with pet?")
        if waitforbutton()
            exercised = 0
            while exercised < 6
                update_image(pet_catch_stick_image)
                showall(win)
                GAccessor.text(label, "Yay! Let's play with the stick!\nCan you throw it for me?")
                throwdistance = rand(1:5)
                if throwdistance < 3
                    GAccessor.text(label, "Good throw.\nYay caught it, again, again!")
                    exercised += 2
                    sleep(2)
                else
                    GAccessor.text(label, "Big throw\nWoah, that was a long way to run!")
                    exercised += 3
                    sleep(2)
                end
            end
            increase_health(pet)
            if pet.health < 8
                GAccessor.text(label, "That's enough running around now.\n" *
                    "Health has increased to $(pet.health)")
            else
                GAccessor.text(label, "Health is at its maximum of $(pet.health)!")
            end
            update_image(pet_default_image)
        else
            decrease_health(pet)
            GAccessor.text(label, "Health has decreased to $(pet.health).")
        end
    end

    function nap()
        GAccessor.text(label, "Would you like to put Puppy to bed?")
        if waitforbutton()
            update_image(pet_sleeping_image)
            showall(win)
            increase_health(pet)
            if pet.health < 8
                GAccessor.text(label, "Health has increased to $(pet.health)\n" *
                    "Zzzzzz...Zzzzzz...Puppy still sleeping...")
            elseif pet.health == 8
                GAccessor.text(label, "Health is at maximum of $(pet.health).\n" *
                    "Zzzzzz...Zzzzzz...Puppy sleeping...")
            end
        else
            decrease_health(pet)
            GAccessor.text(label, "Are you sure? Puppy is so sleepy!\nHealth has decreased to $(pet.health).")
        end
    end

    function chase_tail()
        GAccessor.text(label, "Puppy is bored...")
        sleep(2)
        GAccessor.text(label, "Puppy is having lots of fun chasing his tail...can't quite catch it!")
        update_image(pet_tailchase_image)
        showall(win)
        sleep(4)
        increase_happiness(pet)
        GAccessor.text(label, "Happiness is now $(pet.happiness)!")
    end

    function poop()
        update_image(pet_poop_image)
        showall(win)
        GAccessor.text(label, "Oops, Puppy dumped poop!  Clean up the feces?")
        if waitforbutton()
            increase_happiness(pet)
            GAccessor.text(label, "Puppy feels much better now.\n" *
            (pet.happiness < 8 ? "Happiness has increased to $(pet.happiness)!" :
                                "Happiness is $(pet.happiness)."))
            update_image(pet_default_image)
            showall(win)
            poop_chance -= 0.3
        else
            decrease_happiness(pet)
            GAccessor.text(label, "But not cleaning up will make Puppy sick!\n" *
                "Happiness has decreased to $(pet.happiness).")
        end
    end

    function walk()
        GAccessor.text(label, "Would Puppy like to go for a walk?")
        if waitforbutton()
            GAccessor.text(label, "Yay! Off we go...")
            increase_health(pet)
            if pet.health < 8
                GAccessor.text(label, "Health has increased to $(pet.health)!")
            elseif pet.health == 8
                GAccessor.text(label, "Health is $(pet.health).")
            end
            update_image(pet_walk_image)
        else
            decrease_health(pet)
            GAccessor.text(label, "Oh, but Puppy needs his exercise!\n " *
                "Health has decreased to $(pet.health).")
        end
    end

    function death()
        GAccessor.text(label, "We will miss our pet...")
        update_image(pet_death_image)
    end

    function vet()
        update_image(pet_sick_image)
        showall(win)
        GAccessor.text(label, "Puppy is sick! Take pet to vetenarian?")
        if waitforbutton()
            GAccessor.text(label, "Yay! We got pet medication!")
            update_image(pet_vet_image)
            showall(win)
            sleep(3)
            pet.health = 7
            pet.happiness = 4
            pet.weight = 4
            GAccessor.text(label, "Health has increased to $(pet.health)!")
        else
            decrease_health(pet)
            GAccessor.text(label, "Oh, but Puppy is getting sicker!\n" *
                "Health has decreased to $(pet.health).")
        end
    end

    function tamagotchi_loop()
        while true
            update_status()
            update_image(pet.health < 4 ? pet_sick_image : pet_default_image)
            pet.age += 1
            if (pet.age > 3653 && rand() < age_end_chance) ||
               (pet.health <= 2 && rand() < health_end_chance)
                death()
                break
            elseif pet.health < 4 && rand() < 0.3
                vet()
            elseif rand() < poop_chance && pet.hunger < 6
                poop()
            elseif rand() < 0.2 * (pet.hunger - 2)
                hungry()
            else
                rand([cuddles, hungry, play_stick, nap, walk, chase_tail])()
            end
            if (pet.weight < 3 || pet.happiness < 3) && pet.health > 4
                warn_dialog(request(pet))
                pet.health -= 1
            end
            increase_hunger(pet)
            update_status()
            showall(win)
            sleep(5)
        end
    end

    yes_clicked_callback(widget) = (button_yes = true; button_no = false)
    no_clicked_callback(widget) = (button_no = true; button_yes = false)
    clear_buttons() = (button_no = false; button_yes = false)
    id_yes = signal_connect(yes_clicked_callback, button1, "clicked")
    id_no = signal_connect(no_clicked_callback, button2, "clicked")
    condition = Condition()
    endit(window) = notify(condition)
    signal_connect(endit, win, :destroy)
    showall(win)
    tamagotchi_loop()
end

TamagotchiApp()
