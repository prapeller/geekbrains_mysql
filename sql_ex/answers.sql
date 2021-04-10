# 1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
use sql_ex;
select model, speed, hd
from PC
where price < 500;

# 2. Найдите производителей принтеров. Вывести: maker
select distinct maker
from Product
where type = 'Printer';

# 3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
select model, ram, screen
from laptop
where price > 1000;

# 4. Найдите все записи таблицы Printer для цветных принтеров.
select *
from Printer
where color = 'y';

# 5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
select model, speed, hd
from PC
where price < 600
  and (cd = '12x' OR cd = '24x');

# 6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
select distinct p.maker, l.speed
from product p
         right join laptop l on p.model = l.model
where l.hd >= 10;

# 7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
select pc.model, pc.price
from product
         right join pc on pc.model = product.model
where product.maker = 'B'
union
select laptop.model, laptop.price
from product
         right join laptop on laptop.model = product.model
where product.maker = 'B'
union
select printer.model, printer.price
from product
         right join printer on printer.model = product.model
where product.maker = 'B';

# 8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.
select distinct maker
from product
where type = 'PC'
  and maker not in (select distinct maker from product where type = 'laptop');

# 9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
select distinct p.maker
from product p
         inner join pc on (p.model = pc.model and pc.speed >= 450);

# 10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
select model, price
from printer
where price = (select max(price) from printer);

# 11. Найдите среднюю скорость ПК.
select avg(speed)
from pc;

# 12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
select avg(l.speed)
from laptop l
where l.price > 1000;

# 13. Найдите среднюю скорость ПК, выпущенных производителем A.
select avg(pc.speed)
from pc
where pc.model in (select product.model from product where maker = 'A');

# 14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
select s.class, s.name, c.country
from ships s
         inner join classes c on s.class = c.class
where c.numGuns >= 10;

# 15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
select hd
from (select count(model) count, hd from pc group by hd) qty
where qty.count >= 2;

# 16. Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз,
# т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.\
select distinct pc1.model, pc2.model, pc1.speed, pc1.ram
from pc pc1
         join pc pc2
              on (pc1.speed = pc2.speed and pc1.ram = pc2.ram) and (pc1.model > pc2.model);

# 17. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed
select distinct (select type from product p where p.model = l.model) type, l.model, l.speed
from laptop l
where l.speed < all (select pc.speed from pc);

# 18. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
select distinct product.maker, printer.price
from product
         inner join printer on (printer.model = product.model and
                                printer.price = (select min(p.price) from printer p where p.color = 'y') and
                                product.type = 'printer' and printer.color = 'y');

# 19. Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
# Вывести: maker, средний размер экрана.
select product.maker, avg(laptop.screen)
from laptop
         inner join product on laptop.model = product.model
group by product.maker;

# 20. Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
select maker, cnt
from (select maker, count(model) cnt from product where type = 'PC' group by maker) foo
where cnt >= 3;